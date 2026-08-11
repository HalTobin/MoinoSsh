import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class RevealInFileManager {
    /// Opens the platform file manager at [filePath], selecting the file when
    /// the platform supports it.
    static Future<bool> reveal(String filePath) async {
        final trimmed = filePath.trim();
        if (trimmed.isEmpty) {
            return false;
        }

        final file = File(trimmed);
        if (!await file.exists()) {
            if (kDebugMode) {
                print('[RevealInFileManager] File not found: $trimmed');
            }
            return false;
        }

        try {
            if (Platform.isMacOS) {
                final result = await Process.run('open', ['-R', trimmed]);
                return result.exitCode == 0;
            }

            if (Platform.isWindows) {
                final result = await Process.run(
                    'explorer',
                    ['/select,', trimmed],
                );
                // explorer often returns a non-zero code even on success
                return result.exitCode == 0 || result.exitCode == 1;
            }

            if (Platform.isLinux) {
                final result = await Process.run(
                    'xdg-open',
                    [p.dirname(trimmed)],
                );
                return result.exitCode == 0;
            }

            if (kDebugMode) {
                print(
                    '[RevealInFileManager] Unsupported platform for reveal: '
                    '${Platform.operatingSystem}',
                );
            }
            return false;
        } catch (error) {
            if (kDebugMode) {
                print('[RevealInFileManager] Failed to reveal "$trimmed": $error');
            }
            return false;
        }
    }
}
