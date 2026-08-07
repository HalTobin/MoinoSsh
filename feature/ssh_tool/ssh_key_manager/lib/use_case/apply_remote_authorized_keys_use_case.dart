import 'package:domain/service/sftp_service.dart';
import 'package:path/path.dart' as p;

import '../model/authorized_key_entry.dart';

class ApplyRemoteAuthorizedKeysUseCase {
    ApplyRemoteAuthorizedKeysUseCase({
        required SftpService sftpService,
    }) : _sftpService = sftpService;

    final SftpService _sftpService;

    Future<bool> execute({
        required String authorizedKeysPath,
        required List<AuthorizedKeyEntry> currentEntries,
        required List<String> stagedPublicKeyLines,
    }) async {
        final sshDirectory = p.dirname(authorizedKeysPath);
        if (!await _sftpService.exists(sshDirectory)) {
            await _sftpService.createDirectory(sshDirectory);
        }

        final content = _buildContent(currentEntries, stagedPublicKeyLines);
        return _sftpService.writeStringFile(authorizedKeysPath, content);
    }

    String _buildContent(
        List<AuthorizedKeyEntry> currentEntries,
        List<String> stagedPublicKeyLines,
    ) {
        final lines = <String>[];

        for (final entry in currentEntries) {
            if (!entry.markedForDeletion) {
                lines.add(entry.line);
            }
        }

        lines.addAll(stagedPublicKeyLines);

        if (lines.isEmpty) {
            return '';
        }

        return '${lines.join('\n')}\n';
    }
}
