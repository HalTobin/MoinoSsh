import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

class LoadSshFile {

    static bool isKeyProtected(String filePath) {
        final file = File(filePath);

        if (!file.existsSync()) {
            throw FileSystemException("SSH file not found", filePath);
        }

        final content = file.readAsStringSync();
        return isKeyContentProtected(content);
    }

    static bool isKeyContentProtected(String content) {
        if (content.contains('Proc-Type: 4,ENCRYPTED')) {
            return true;
        }

        try {
            final pem = SSHPem.decode(content);
            switch (pem.type) {
                case 'OPENSSH PRIVATE KEY':
                    return OpenSSHKeyPairs.decode(pem.content).isEncrypted;
                case 'RSA PRIVATE KEY':
                    return RsaKeyPair.decode(pem).isEncrypted ||
                        content.contains('ENCRYPTED');
                default:
                    return content.contains('ENCRYPTED');
            }
        } catch (_) {
            // Keep the legacy markers as a last resort for unusual formats.
            return content.contains('ENCRYPTED') ||
                content.contains('Proc-Type: 4,ENCRYPTED');
        }
    }

}
