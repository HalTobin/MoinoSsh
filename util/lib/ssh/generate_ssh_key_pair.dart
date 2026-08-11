import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' hide SecureRandom;
import 'package:dartssh2/dartssh2.dart';
import 'package:pointycastle/export.dart';

import 'openssh_private_key_encryption.dart';
import 'ssh_key_algorithm.dart';

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
        SshKeyAlgorithm algorithm = SshKeyAlgorithm.ed25519,
    }) async {
        final sanitizedName = _sanitizeFileName(name, algorithm);
        final keyPair = await _createKeyPair(
            algorithm: algorithm,
            comment: sanitizedName,
        );

        final publicBlob = keyPair.toPublicKey().encode();
        final publicLine =
            '${keyPair.name} ${base64.encode(publicBlob)} $sanitizedName';
        final privateContent = _encodePrivateKey(
            keyPair: keyPair,
            passphrase: passphrase,
        );

        return GeneratedSshKeyPair(
            privateKeyContent: privateContent,
            publicKeyLine: publicLine.trim(),
            privateKeyFileName: sanitizedName,
        );
    }

    static Future<SSHKeyPair> _createKeyPair({
        required SshKeyAlgorithm algorithm,
        required String comment,
    }) async {
        switch (algorithm) {
            case SshKeyAlgorithm.ed25519:
                return _generateEd25519(comment);
            case SshKeyAlgorithm.rsa2048:
            case SshKeyAlgorithm.rsa3072:
            case SshKeyAlgorithm.rsa4096:
                return _generateRsa(
                    bitLength: algorithm.rsaBits!,
                    comment: comment,
                );
            case SshKeyAlgorithm.ecdsaP256:
            case SshKeyAlgorithm.ecdsaP384:
            case SshKeyAlgorithm.ecdsaP521:
                return _generateEcdsa(
                    curveId: algorithm.ecdsaCurveId!,
                    comment: comment,
                );
        }
    }

    static Future<OpenSSHEd25519KeyPair> _generateEd25519(String comment) async {
        final keyPair = await Ed25519().newKeyPair();
        final privateSeed = await keyPair.extractPrivateKeyBytes();
        final publicKey = await keyPair.extractPublicKey();
        final publicBytes = Uint8List.fromList(publicKey.bytes);
        final openSshPrivateKey = Uint8List.fromList([
            ...privateSeed,
            ...publicKey.bytes,
        ]);

        return OpenSSHEd25519KeyPair(
            publicBytes,
            openSshPrivateKey,
            comment,
        );
    }

    static OpenSSHRsaKeyPair _generateRsa({
        required int bitLength,
        required String comment,
    }) {
        final secureRandom = _secureRandom();
        final keyGen = RSAKeyGenerator()
            ..init(
                ParametersWithRandom(
                    RSAKeyGeneratorParameters(
                        BigInt.parse('65537'),
                        bitLength,
                        64,
                    ),
                    secureRandom,
                ),
            );

        final pair = keyGen.generateKeyPair();
        final privateKey = pair.privateKey as RSAPrivateKey;
        final publicKey = pair.publicKey as RSAPublicKey;

        final n = publicKey.modulus!;
        final e = publicKey.exponent!;
        final d = privateKey.privateExponent!;
        final p = privateKey.p!;
        final q = privateKey.q!;
        final iqmp = q.modInverse(p);

        return OpenSSHRsaKeyPair(n, e, d, iqmp, p, q, comment);
    }

    static OpenSSHEcdsaKeyPair _generateEcdsa({
        required String curveId,
        required String comment,
    }) {
        final domain = _ecDomain(curveId);
        final secureRandom = _secureRandom();
        final keyGen = ECKeyGenerator()
            ..init(
                ParametersWithRandom(
                    ECKeyGeneratorParameters(domain),
                    secureRandom,
                ),
            );

        final pair = keyGen.generateKeyPair();
        final privateKey = pair.privateKey as ECPrivateKey;
        final publicKey = pair.publicKey as ECPublicKey;
        final q = Uint8List.fromList(publicKey.Q!.getEncoded(false));

        return OpenSSHEcdsaKeyPair(curveId, q, privateKey.d!, comment);
    }

    static ECDomainParameters _ecDomain(String curveId) {
        switch (curveId) {
            case 'nistp256':
                return ECCurve_secp256r1();
            case 'nistp384':
                return ECCurve_secp384r1();
            case 'nistp521':
                return ECCurve_secp521r1();
            default:
                throw UnsupportedError('Unsupported ECDSA curve: $curveId');
        }
    }

    static String _encodePrivateKey({
        required SSHKeyPair keyPair,
        String? passphrase,
    }) {
        final unencryptedPem = keyPair.toPem();

        if (passphrase == null || passphrase.isEmpty) {
            return unencryptedPem;
        }

        final unencryptedPairs = OpenSSHKeyPairs.decode(
            SSHPem.decode(unencryptedPem).content,
        );

        return OpenSshPrivateKeyEncryption.encrypt(
            unencryptedPairs: unencryptedPairs,
            passphrase: passphrase,
        ).toPem();
    }

    static SecureRandom _secureRandom() {
        final secureRandom = FortunaRandom();
        final seed = Uint8List.fromList(
            List.generate(32, (_) => Random.secure().nextInt(256)),
        );
        secureRandom.seed(KeyParameter(seed));
        return secureRandom;
    }

    static String _sanitizeFileName(String name, SshKeyAlgorithm algorithm) {
        final trimmed = name.trim();
        if (trimmed.isEmpty) {
            return algorithm.defaultFileName;
        }

        final sanitized = trimmed.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        if (sanitized.endsWith('.pub')) {
            return sanitized.substring(0, sanitized.length - 4);
        }
        return sanitized;
    }
}
