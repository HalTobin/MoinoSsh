import 'package:cryptography/cryptography.dart';
import 'package:openssh_ed25519/openssh_ed25519.dart';

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
    static Future<GeneratedSshKeyPair> generate({required String name}) async {
        final sanitizedName = _sanitizeFileName(name);
        final keyPair = await Ed25519().newKeyPair();
        final privateBytes = await keyPair.extractPrivateKeyBytes();
        final publicKey = await keyPair.extractPublicKey();

        final publicLine = encodeEd25519Public(publicKey.bytes, sanitizedName);
        final privateContent = encodeEd25519Private(
            privateBytes: privateBytes,
            publicBytes: publicKey.bytes,
        );

        return GeneratedSshKeyPair(
            privateKeyContent: privateContent,
            publicKeyLine: publicLine.trim(),
            privateKeyFileName: sanitizedName,
        );
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
