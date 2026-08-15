import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

import 'public_key_line.dart';

class SshKeyDetails {
    final String algorithm;
    final String algorithmLabel;
    final String publicKeyLine;

    const SshKeyDetails({
        required this.algorithm,
        required this.algorithmLabel,
        required this.publicKeyLine,
    });
}

class SshKeyDetailsLoadException implements Exception {
    final String message;
    final bool passwordRequired;

    const SshKeyDetailsLoadException(
        this.message, {
        this.passwordRequired = false,
    });

    @override
    String toString() => message;
}

class LoadSshKeyDetails {
    static String? readAlgorithmLabel(String filePath) {
        try {
            final siblingPub = _readSiblingPublicKey(filePath);
            if (siblingPub != null) {
                return siblingPub.algorithmLabel;
            }

            final content = File(filePath).readAsStringSync();
            return _readAlgorithmLabelFromPrivatePem(content);
        } catch (_) {
            return null;
        }
    }

    static SshKeyDetails load(
        String filePath, {
        String? passphrase,
        String? comment,
    }) {
        final siblingPub = _readSiblingPublicKey(filePath);
        if (siblingPub != null) {
            return siblingPub;
        }

        final file = File(filePath);
        if (!file.existsSync()) {
            throw const SshKeyDetailsLoadException('SSH key file not found');
        }

        final content = file.readAsStringSync();
        final resolvedComment = (comment == null || comment.trim().isEmpty)
            ? (file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : 'moino')
            : comment.trim();

        try {
            final pem = SSHPem.decode(content);
            switch (pem.type) {
                case 'OPENSSH PRIVATE KEY':
                    return _fromOpenSshPrivateKey(
                        pem.content,
                        comment: resolvedComment,
                    );
                case 'RSA PRIVATE KEY':
                    return _fromPemKeyPairs(
                        content,
                        passphrase: passphrase,
                        comment: resolvedComment,
                    );
                default:
                    throw SshKeyDetailsLoadException(
                        'Unsupported key type: ${pem.type}',
                    );
            }
        } on SSHKeyDecryptError {
            throw const SshKeyDetailsLoadException(
                'Password required to read this key',
                passwordRequired: true,
            );
        } on SshKeyDetailsLoadException {
            rethrow;
        } catch (error) {
            final message = error.toString().toLowerCase();
            if (message.contains('encrypted') ||
                message.contains('passphrase') ||
                message.contains('decrypt')) {
                throw const SshKeyDetailsLoadException(
                    'Password required to read this key',
                    passwordRequired: true,
                );
            }
            throw SshKeyDetailsLoadException('Could not read public key: $error');
        }
    }

    static String? _readAlgorithmLabelFromPrivatePem(String content) {
        final pem = SSHPem.decode(content);
        switch (pem.type) {
            case 'OPENSSH PRIVATE KEY':
                final pairs = OpenSSHKeyPairs.decode(pem.content);
                if (pairs.publicKeys.isEmpty) {
                    return null;
                }
                return algorithmLabel(_readAlgorithm(pairs.publicKeys.first));
            case 'RSA PRIVATE KEY':
                return algorithmLabel('ssh-rsa');
            default:
                return null;
        }
    }

    static SshKeyDetails? _readSiblingPublicKey(String privateKeyPath) {
        final candidate = File('$privateKeyPath.pub');
        if (!candidate.existsSync()) {
            return null;
        }

        final line = candidate.readAsStringSync().trim();
        if (line.isEmpty) {
            return null;
        }

        final parts = line.split(RegExp(r'\s+'));
        if (parts.isEmpty) {
            return null;
        }

        final algorithm = parts.first;
        return SshKeyDetails(
            algorithm: algorithm,
            algorithmLabel: algorithmLabel(algorithm),
            publicKeyLine: line,
        );
    }

    static SshKeyDetails _fromOpenSshPrivateKey(
        Uint8List keyBlob, {
        required String comment,
    }) {
        final pairs = OpenSSHKeyPairs.decode(keyBlob);
        if (pairs.publicKeys.isEmpty) {
            throw const SshKeyDetailsLoadException(
                'No public key found in private key file',
            );
        }

        final publicBlob = pairs.publicKeys.first;
        final algorithm = _readAlgorithm(publicBlob);
        return SshKeyDetails(
            algorithm: algorithm,
            algorithmLabel: algorithmLabel(algorithm),
            publicKeyLine: '$algorithm ${base64.encode(publicBlob)} $comment',
        );
    }

    static SshKeyDetails _fromPemKeyPairs(
        String pemContent, {
        String? passphrase,
        required String comment,
    }) {
        final pairs = SSHKeyPair.fromPem(pemContent, passphrase);
        if (pairs.isEmpty) {
            throw const SshKeyDetailsLoadException('No key pair found in file');
        }

        final keyPair = pairs.first;
        final publicBlob = keyPair.toPublicKey().encode();
        final algorithm = keyPair.type;
        return SshKeyDetails(
            algorithm: algorithm,
            algorithmLabel: algorithmLabel(algorithm),
            publicKeyLine: '$algorithm ${base64.encode(publicBlob)} $comment',
        );
    }

    static String _readAlgorithm(Uint8List encodedHostKey) {
        final algorithm = SshPublicKeyLine.readBlobAlgorithm(encodedHostKey);
        if (algorithm == null) {
            throw const SshKeyDetailsLoadException('Invalid public key blob');
        }
        return algorithm;
    }

    static String algorithmLabel(String algorithm) {
        switch (algorithm) {
            case 'ssh-ed25519':
                return 'Ed25519';
            case 'ssh-rsa':
            case 'rsa-sha2-256':
            case 'rsa-sha2-512':
                return 'RSA';
            default:
                if (algorithm.startsWith('ecdsa-sha2-')) {
                    final curve = algorithm.substring('ecdsa-sha2-'.length);
                    return 'ECDSA ($curve)';
                }
                return algorithm;
        }
    }
}
