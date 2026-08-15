import 'package:domain/model/response_result.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../model/authorized_key_entry.dart';

class ApplyRemoteAuthorizedKeysUseCase {
    ApplyRemoteAuthorizedKeysUseCase({
        required SftpService sftpService,
        required SshService sshService,
    }) : _sftpService = sftpService,
         _sshService = sshService;

    final SftpService _sftpService;
    final SshService _sshService;

    Future<ResponseResult<bool>> execute({
        required String authorizedKeysPath,
        required List<AuthorizedKeyEntry> currentEntries,
        required List<String> stagedPublicKeyLines,
    }) async {
        final sshDirectory = p.posix.dirname(authorizedKeysPath);
        if (!await _sftpService.exists(sshDirectory)) {
            await _sftpService.createDirectory(sshDirectory);
        }

        final content = _buildContent(currentEntries, stagedPublicKeyLines);
        final written = await _sftpService.writeStringFileAtomically(
            authorizedKeysPath,
            content,
        );
        switch (written) {
            case ResponseSucceed():
                return written;
            case ResponseFailed(error: final error):
                if (kDebugMode) {
                    print('Direct write failed, retrying with sudo: $error');
                }
        }

        return _sshService.writeFileWithSudo(
            filePath: authorizedKeysPath,
            content: content,
        );
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
