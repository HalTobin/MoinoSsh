import 'dart:convert';
import 'dart:io';

class LoadSshFile {

    static bool isKeyProtected(String filePath) {
        final file = File(filePath);

        if (!file.existsSync()) {
            throw FileSystemException("SSH file not found", filePath);
        }

        final content = file.readAsStringSync();

        if (content.contains('ENCRYPTED') || content.contains('Proc-Type: 4,ENCRYPTED')) {
            return true;
        }

        // Detect OpenSSH new format
        const beginMarker = '-----BEGIN OPENSSH PRIVATE KEY-----';
        const endMarker = '-----END OPENSSH PRIVATE KEY-----';

        if (content.contains(beginMarker)) {
            try {
                final base64Content = content
                    .split(beginMarker)[1]
                    .split(endMarker)[0]
                    .replaceAll(RegExp(r'\s+'), '');

                final decodedBytes = base64.decode(base64Content);

                // Check for "bcrypt" indicating encryption
                return utf8.decode(decodedBytes).contains('bcrypt');
            } catch (_) {
                // If decoding fails, assume encrypted as a precaution
                return true;
            }
        }

        // Default: assume unencrypted if nothing matches
        return false;
    }

}