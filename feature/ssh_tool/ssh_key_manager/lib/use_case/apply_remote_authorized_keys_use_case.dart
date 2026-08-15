import 'package:domain/model/response_result.dart';
import 'package:domain/model/text_file.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:util/text/content_digest.dart';

import '../model/apply_authorized_keys_result.dart';
import '../model/authorized_keys_file.dart';

/// `0700`: sshd refuses keys from a directory other accounts can write to.
final int _sshDirectoryMode = int.parse('700', radix: 8);

class ApplyRemoteAuthorizedKeysUseCase {
    ApplyRemoteAuthorizedKeysUseCase({
        required SftpService sftpService,
        required SshService sshService,
    }) : _sftpService = sftpService,
         _sshService = sshService;

    final SftpService _sftpService;
    final SshService _sshService;

    Future<ApplyAuthorizedKeysResult> execute({
        required String authorizedKeysPath,
        required AuthorizedKeysFile file,
        required List<String> stagedPublicKeyLines,
        required bool expectedFileExists,
        required String expectedContentHash,
    }) async {
        final unchanged = await _remoteIsUnchanged(
            authorizedKeysPath: authorizedKeysPath,
            expectedFileExists: expectedFileExists,
            expectedContentHash: expectedContentHash,
        );
        switch (unchanged) {
            case ResponseFailed(error: final error):
                return ApplyAuthorizedKeysFailed(error);
            case ResponseSucceed(data: final isUnchanged):
                if (!isUnchanged) {
                    return const ApplyAuthorizedKeysConflict();
                }
        }

        final sshDirectory = p.posix.dirname(authorizedKeysPath);
        if (!await _sftpService.exists(sshDirectory)) {
            await _sftpService.createDirectory(
                sshDirectory,
                mode: _sshDirectoryMode,
            );
        }

        final content = file.render(stagedPublicKeyLines: stagedPublicKeyLines);
        final written = await _sftpService.writeStringFileAtomically(
            authorizedKeysPath,
            content,
        );
        switch (written) {
            case ResponseSucceed():
                return const ApplyAuthorizedKeysSucceeded();
            case ResponseFailed(error: final error):
                if (kDebugMode) {
                    print('Direct write failed, retrying with sudo: $error');
                }
        }

        final withSudo = await _sshService.writeFileWithSudo(
            filePath: authorizedKeysPath,
            content: content,
        );
        return switch (withSudo) {
            ResponseSucceed() => const ApplyAuthorizedKeysSucceeded(),
            ResponseFailed(error: final error) => ApplyAuthorizedKeysFailed(
                error.isNotEmpty ? error : 'Could not update remote authorized_keys',
            ),
        };
    }

    /// Confirms the file still holds what was read into the snapshot. A read
    /// failure is reported rather than assumed safe, so nothing is overwritten
    /// on the strength of a guess.
    Future<ResponseResult<bool>> _remoteIsUnchanged({
        required String authorizedKeysPath,
        required bool expectedFileExists,
        required String expectedContentHash,
    }) async {
        final result = await _sftpService.readTextFileIfExists(authorizedKeysPath);
        return switch (result) {
            ResponseFailed(error: final error) => ResponseFailed(error: error),
            ResponseSucceed(data: final TextFile? file) => ResponseSucceed(
                file == null
                    ? !expectedFileExists
                    : expectedFileExists &&
                        ContentDigest.of(file.content) == expectedContentHash,
            ),
        };
    }
}
