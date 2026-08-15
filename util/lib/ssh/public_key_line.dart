import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';

import 'ssh_key_details.dart';

/// A single OpenSSH public key line, as written in an `authorized_keys` file:
/// an optional options field, the key type, the base64 key blob and an optional
/// comment.
class SshPublicKeyLine {
    /// Leading options such as `no-pty` or `from="10.0.0.1"`, when present.
    final String? options;

    /// Key type as written on the line, e.g. `ssh-ed25519`.
    final String algorithm;

    /// The key blob exactly as it appeared on the line.
    final String encodedKey;

    /// Trailing comment, usually `user@host`. Null when the line has none.
    final String? comment;

    /// The decoded [encodedKey].
    final Uint8List keyBlob;

    const SshPublicKeyLine._({
        required this.options,
        required this.algorithm,
        required this.encodedKey,
        required this.comment,
        required this.keyBlob,
    });

    String get algorithmLabel => LoadSshKeyDetails.algorithmLabel(algorithm);

    /// `SHA256:...` fingerprint, matching the output of `ssh-keygen -lf`.
    String get fingerprint {
        final digest = SHA256Digest().process(keyBlob);
        return 'SHA256:${base64.encode(digest).replaceAll('=', '')}';
    }

    /// Identifies the key material itself, ignoring options and comment, so the
    /// same key offered twice under different comments counts as a duplicate.
    String get identity => '$algorithm ${base64.encode(keyBlob)}';

    /// Rebuilds a canonical single-space line. Existing lines should be written
    /// back verbatim instead; this is for keys the user just added.
    String format() {
        return [
            if (options != null && options!.isNotEmpty) options!,
            algorithm,
            encodedKey,
            if (comment != null && comment!.isNotEmpty) comment!,
        ].join(' ');
    }

    /// Parses [line], reporting why it was rejected when it is not a usable
    /// public key line.
    static SshPublicKeyParseResult parse(String line) {
        final normalized = line.trim();
        if (normalized.isEmpty) {
            return const SshPublicKeyInvalid('Enter a public key line');
        }
        if (normalized.toUpperCase().contains('PRIVATE KEY')) {
            return const SshPublicKeyInvalid(
                'This is a private key. Paste the matching public key (.pub) instead.',
            );
        }
        if (normalized.contains('\n') || normalized.contains('\r')) {
            return const SshPublicKeyInvalid(
                'Paste a single public key line, not a block of text',
            );
        }
        if (_hasControlCharacter(normalized)) {
            return const SshPublicKeyInvalid(
                'The key line contains characters that are not allowed',
            );
        }

        final firstEnd = _endOfField(normalized, 0);
        final firstField = normalized.substring(0, firstEnd);

        final String? options;
        final String algorithm;
        final int afterAlgorithm;
        if (isKnownAlgorithm(firstField)) {
            options = null;
            algorithm = firstField;
            afterAlgorithm = firstEnd;
        } else {
            // Only an options field may precede the key type.
            final secondStart = _skipBlanks(normalized, firstEnd);
            final secondEnd = _endOfField(normalized, secondStart);
            final secondField = normalized.substring(secondStart, secondEnd);
            if (secondField.isEmpty || !isKnownAlgorithm(secondField)) {
                return SshPublicKeyInvalid(
                    '"$firstField" is not a supported key type',
                );
            }
            options = firstField;
            algorithm = secondField;
            afterAlgorithm = secondEnd;
        }

        final keyStart = _skipBlanks(normalized, afterAlgorithm);
        final keyEnd = _endOfField(normalized, keyStart);
        final encodedKey = normalized.substring(keyStart, keyEnd);
        if (encodedKey.isEmpty) {
            return const SshPublicKeyInvalid('The key data is missing');
        }

        final Uint8List keyBlob;
        try {
            keyBlob = base64.decode(base64.normalize(encodedKey));
        } catch (_) {
            return const SshPublicKeyInvalid('The key data is not valid base64');
        }

        // The blob repeats its own algorithm name. Comparing it catches
        // truncated pastes and text that merely looks like a key.
        final blobAlgorithm = readBlobAlgorithm(keyBlob);
        if (blobAlgorithm == null) {
            return const SshPublicKeyInvalid('The key data is not a public key');
        }
        if (blobAlgorithm != algorithm) {
            return SshPublicKeyInvalid(
                'The key data is a $blobAlgorithm key but the line says $algorithm',
            );
        }

        final commentStart = _skipBlanks(normalized, keyEnd);
        final comment = commentStart < normalized.length
            ? normalized.substring(commentStart).trim()
            : null;

        return SshPublicKeyValid(
            SshPublicKeyLine._(
                options: options,
                algorithm: algorithm,
                encodedKey: encodedKey,
                comment: (comment == null || comment.isEmpty) ? null : comment,
                keyBlob: keyBlob,
            ),
        );
    }

    /// Parses [line], returning null when it is not a usable public key line.
    static SshPublicKeyLine? tryParse(String line) {
        final result = parse(line);
        return switch (result) {
            SshPublicKeyValid(:final key) => key,
            SshPublicKeyInvalid() => null,
        };
    }

    /// Reads the algorithm name embedded at the start of an SSH public key blob.
    /// Returns null when [keyBlob] is not shaped like one.
    static String? readBlobAlgorithm(Uint8List keyBlob) {
        if (keyBlob.length < 4) {
            return null;
        }
        final length = ByteData.sublistView(keyBlob).getUint32(0);
        final end = 4 + length;
        if (length <= 0 || end > keyBlob.length) {
            return null;
        }
        try {
            return utf8.decode(keyBlob.sublist(4, end));
        } catch (_) {
            return null;
        }
    }

    static bool isKnownAlgorithm(String value) {
        if (_knownAlgorithms.contains(value) ||
            _knownCertificateAlgorithms.contains(value)) {
            return true;
        }
        if (value.endsWith(_certificateSuffix)) {
            final base = value.substring(
                0,
                value.length - _certificateSuffix.length,
            );
            return _knownAlgorithms.contains(base);
        }
        return false;
    }

    static bool _hasControlCharacter(String value) {
        for (final unit in value.codeUnits) {
            if (unit < 0x20 || unit == 0x7F) {
                return true;
            }
        }
        return false;
    }

    /// Index of the first blank that ends the field starting at [start], taking
    /// quoted option values into account.
    static int _endOfField(String value, int start) {
        var insideQuotes = false;
        for (var i = start; i < value.length; i++) {
            final char = value[i];
            if (char == r'\') {
                i++;
                continue;
            }
            if (char == '"') {
                insideQuotes = !insideQuotes;
                continue;
            }
            if (!insideQuotes && (char == ' ' || char == '\t')) {
                return i;
            }
        }
        return value.length;
    }

    static int _skipBlanks(String value, int start) {
        var index = start;
        while (index < value.length &&
            (value[index] == ' ' || value[index] == '\t')) {
            index++;
        }
        return index;
    }

    static const String _certificateSuffix = '-cert-v01@openssh.com';

    static const Set<String> _knownAlgorithms = {
        'ssh-ed25519',
        'ssh-ed448',
        'ssh-rsa',
        'rsa-sha2-256',
        'rsa-sha2-512',
        'ssh-dss',
        'ecdsa-sha2-nistp256',
        'ecdsa-sha2-nistp384',
        'ecdsa-sha2-nistp521',
        'sk-ssh-ed25519@openssh.com',
        'sk-ecdsa-sha2-nistp256@openssh.com',
    };

    static const Set<String> _knownCertificateAlgorithms = {
        'sk-ssh-ed25519-cert-v01@openssh.com',
        'sk-ecdsa-sha2-nistp256-cert-v01@openssh.com',
    };
}

sealed class SshPublicKeyParseResult {
    const SshPublicKeyParseResult();
}

class SshPublicKeyValid extends SshPublicKeyParseResult {
    final SshPublicKeyLine key;
    const SshPublicKeyValid(this.key);
}

class SshPublicKeyInvalid extends SshPublicKeyParseResult {
    final String message;
    const SshPublicKeyInvalid(this.message);
}
