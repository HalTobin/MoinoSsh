import 'package:domain/model/response_result.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_service.dart';

import '../model/authorized_key_entry.dart';

class GetRemoteAuthorizedKeysUseCase {
    GetRemoteAuthorizedKeysUseCase({
        required SshService sshService,
        required SftpService sftpService,
    }) : _sshService = sshService,
         _sftpService = sftpService;

    final SshService _sshService;
    final SftpService _sftpService;

    Future<ResponseResult<RemoteAuthorizedKeysSnapshot>> execute() async {
        final homeResult = await _sshService.executeCommand(r'echo $HOME');
        switch (homeResult) {
            case ResponseSucceed():
                break;
            case ResponseFailed(error: final error):
                return ResponseFailed(error: error);
        }

        final home = homeResult.data;
        if (home.isEmpty) {
            return ResponseFailed(error: 'Could not resolve remote home directory');
        }

        final authorizedKeysPath = '$home/.ssh/authorized_keys';
        final exists = await _sftpService.exists(authorizedKeysPath);
        if (!exists) {
            return ResponseSucceed(
                RemoteAuthorizedKeysSnapshot(
                    authorizedKeysPath: authorizedKeysPath,
                    entries: const [],
                ),
            );
        }

        final file = await _sftpService.readFileAsString(authorizedKeysPath);
        if (file == null) {
            return ResponseFailed(error: 'Could not read $authorizedKeysPath');
        }

        return ResponseSucceed(
            RemoteAuthorizedKeysSnapshot(
                authorizedKeysPath: authorizedKeysPath,
                entries: _parseAuthorizedKeys(file.content),
            ),
        );
    }

    List<AuthorizedKeyEntry> _parseAuthorizedKeys(String content) {
        return content
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty && !line.startsWith('#'))
            .map((line) {
                final parts = line.split(RegExp(r'\s+'));
                final comment = parts.length > 2 ? parts.sublist(2).join(' ') : null;
                return AuthorizedKeyEntry(line: line, comment: comment);
            })
            .toList();
    }
}
