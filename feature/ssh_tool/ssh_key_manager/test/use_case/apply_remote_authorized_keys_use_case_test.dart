import 'package:domain/model/response_result.dart';
import 'package:domain/model/text_file.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:feature_ssh_key_manager/model/apply_authorized_keys_result.dart';
import 'package:feature_ssh_key_manager/model/authorized_keys_file.dart';
import 'package:feature_ssh_key_manager/use_case/apply_remote_authorized_keys_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:util/text/content_digest.dart';

const _keyA =
    'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbqATrCUopG1s0pnzHRRUyKZk9h2iVv4t7YfpaPIBYb test@moino';
const _keyB =
    'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBALp0f4+kmobD2PE9pD+x5tWJUh/uJmARNCry21voReKoxpXEQVMbniSIrPwZWtZsk6tFHngyIjDLlM+rYso6xI=';

const _path = '/home/moino/.ssh/authorized_keys';

/// Only the calls the use case makes are implemented; anything else throws so a
/// new dependency cannot slip in unnoticed.
class _FakeSftpService implements SftpService {
    String? remoteContent;
    bool readFails = false;
    bool writeFails = false;

    String? writtenContent;
    int writeCalls = 0;
    int createDirectoryCalls = 0;

    @override
    Future<ResponseResult<TextFile?>> readTextFileIfExists(String filePath) async {
        if (readFails) {
            return ResponseFailed(error: 'Could not read $filePath');
        }
        final content = remoteContent;
        if (content == null) {
            return ResponseSucceed(null);
        }
        return ResponseSucceed(
            TextFile(name: 'authorized_keys', isEditable: true, content: content),
        );
    }

    @override
    Future<ResponseResult<bool>> writeStringFileAtomically(
        String filePath,
        String content,
    ) async {
        writeCalls++;
        if (writeFails) {
            return ResponseFailed(error: 'Permission denied');
        }
        writtenContent = content;
        remoteContent = content;
        return ResponseSucceed(true);
    }

    @override
    Future<bool> exists(String path) async => true;

    @override
    Future<bool> createDirectory(String path, {int? mode}) async {
        createDirectoryCalls++;
        return true;
    }

    @override
    dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSshService implements SshService {
    bool sudoSucceeds = true;
    int sudoCalls = 0;
    String? sudoContent;

    @override
    Future<ResponseResult<bool>> writeFileWithSudo({
        required String filePath,
        required String content,
    }) async {
        sudoCalls++;
        sudoContent = content;
        if (sudoSucceeds) {
            return ResponseSucceed(true);
        }
        return ResponseFailed(error: 'sudo refused');
    }

    @override
    dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
    late _FakeSftpService sftp;
    late _FakeSshService ssh;
    late ApplyRemoteAuthorizedKeysUseCase useCase;

    setUp(() {
        sftp = _FakeSftpService();
        ssh = _FakeSshService();
        useCase = ApplyRemoteAuthorizedKeysUseCase(sftpService: sftp, sshService: ssh);
    });

    Future<ApplyAuthorizedKeysResult> apply({
        required String loadedContent,
        required AuthorizedKeysFile file,
        List<String> staged = const [],
        bool expectedFileExists = true,
    }) {
        return useCase.execute(
            authorizedKeysPath: _path,
            file: file,
            stagedPublicKeyLines: staged,
            expectedFileExists: expectedFileExists,
            expectedContentHash: loadedContent.isEmpty && !expectedFileExists
                ? ''
                : ContentDigest.of(loadedContent),
        );
    }

    group('when the remote still matches what was read', () {
        test('writes the rendered file', () async {
            const loaded = '# header\n$_keyA\n';
            sftp.remoteContent = loaded;

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
                staged: const [_keyB],
            );

            expect(result, isA<ApplyAuthorizedKeysSucceeded>());
            expect(sftp.writtenContent, '# header\n$_keyA\n$_keyB\n');
        });

        test('creates the file when it was absent', () async {
            sftp.remoteContent = null;

            final result = await apply(
                loadedContent: '',
                file: AuthorizedKeysFile.empty,
                staged: const [_keyA],
                expectedFileExists: false,
            );

            expect(result, isA<ApplyAuthorizedKeysSucceeded>());
            expect(sftp.writtenContent, '$_keyA\n');
        });
    });

    group('conflicts', () {
        test('are reported when the content changed, and nothing is written', () async {
            const loaded = '$_keyA\n';
            sftp.remoteContent = '$_keyA\n$_keyB\n';

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
                staged: const [_keyB],
            );

            expect(result, isA<ApplyAuthorizedKeysConflict>());
            expect(sftp.writeCalls, 0);
            expect(ssh.sudoCalls, 0);
        });

        test('are reported when the file vanished', () async {
            const loaded = '$_keyA\n';
            sftp.remoteContent = null;

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
            );

            expect(result, isA<ApplyAuthorizedKeysConflict>());
            expect(sftp.writeCalls, 0);
        });

        test('are reported when the file appeared after being read as absent', () async {
            sftp.remoteContent = '$_keyB\n';

            final result = await apply(
                loadedContent: '',
                file: AuthorizedKeysFile.empty,
                staged: const [_keyA],
                expectedFileExists: false,
            );

            expect(result, isA<ApplyAuthorizedKeysConflict>());
            expect(sftp.writeCalls, 0);
        });

        test('a whitespace only change still counts as a change', () async {
            const loaded = '$_keyA\n';
            sftp.remoteContent = '$_keyA\n\n';

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
            );

            expect(result, isA<ApplyAuthorizedKeysConflict>());
        });
    });

    group('when the check cannot be made', () {
        test('nothing is written and the failure is reported', () async {
            const loaded = '$_keyA\n';
            sftp.readFails = true;

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
                staged: const [_keyB],
            );

            expect(result, isA<ApplyAuthorizedKeysFailed>());
            expect(sftp.writeCalls, 0);
            expect(ssh.sudoCalls, 0);
        });
    });

    group('sudo fallback', () {
        test('runs when the direct write is refused', () async {
            const loaded = '$_keyA\n';
            sftp.remoteContent = loaded;
            sftp.writeFails = true;

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
                staged: const [_keyB],
            );

            expect(result, isA<ApplyAuthorizedKeysSucceeded>());
            expect(ssh.sudoCalls, 1);
            expect(ssh.sudoContent, '$_keyA\n$_keyB\n');
        });

        test('its failure is surfaced', () async {
            const loaded = '$_keyA\n';
            sftp.remoteContent = loaded;
            sftp.writeFails = true;
            ssh.sudoSucceeds = false;

            final result = await apply(
                loadedContent: loaded,
                file: AuthorizedKeysFile.parse(loaded),
                staged: const [_keyB],
            );

            expect(result, isA<ApplyAuthorizedKeysFailed>());
            expect((result as ApplyAuthorizedKeysFailed).error, 'sudo refused');
        });
    });
}
