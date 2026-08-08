import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:openssh_ed25519/openssh_ed25519.dart';

import 'openssh_private_key_encryption.dart';

class GeneratedSshKeyPair {
    final String privateKeyContent;
    final String publicKeyLine;
    final String privateKeyFileName;

    const GeneratedSshKeyPair({
        required this.privateKeyContent,
        required this.publicKeyLine,
        required this.privateKeyFileName,
    });
}

class GenerateSshKeyPair {
    static Future<GeneratedSshKeyPair> generate({
        required String name,
        String? passphrase,
    }) async {
        final sanitizedName = _sanitizeFileName(name);
        final keyPair = await Ed25519().newKeyPair();
        final privateSeed = await keyPair.extractPrivateKeyBytes();
        final publicKey = await keyPair.extractPublicKey();
        final publicBytes = Uint8List.fromList(publicKey.bytes);
        final openSshPrivateKey = Uint8List.fromList([
            ...privateSeed,
            ...publicKey.bytes,
        ]);

        final publicLine = encodeEd25519Public(publicKey.bytes, sanitizedName);
        final privateContent = _encodePrivateKey(
            publicKey: publicBytes,
            openSshPrivateKey: openSshPrivateKey,
            comment: sanitizedName,
            passphrase: passphrase,
        );

        return GeneratedSshKeyPair(
            privateKeyContent: privateContent,
            publicKeyLine: publicLine.trim(),
            privateKeyFileName: sanitizedName,
        );
    }

    static String _encodePrivateKey({
        required Uint8List publicKey,
        required Uint8List openSshPrivateKey,
        required String comment,
        String? passphrase,
    }) {
        final ed25519KeyPair = OpenSSHEd25519KeyPair(
            publicKey,
            openSshPrivateKey,
            comment,
        );
        final unencryptedPem = ed25519KeyPair.toPem();
        final unencryptedPairs = OpenSSHKeyPairs.decode(
            SSHPem.decode(unencryptedPem).content,
        );

        if (passphrase == null || passphrase.isEmpty) {
            return unencryptedPem;
        }

        return OpenSshPrivateKeyEncryption.encrypt(
            unencryptedPairs: unencryptedPairs,
            passphrase: passphrase,
        ).toPem();
    }

    static String _sanitizeFileName(String name) {
        final trimmed = name.trim();
        if (trimmed.isEmpty) {
            return 'id_ed25519';
        }

        final sanitized = trimmed.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        if (sanitized.endsWith('.pub')) {
            return sanitized.substring(0, sanitized.length - 4);
        }
        return sanitized;
    }
}
