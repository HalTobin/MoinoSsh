import 'dart:convert';

import 'package:data/service/ssh_client_service_impl.dart';

import 'utils/byte_decoder.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:domain/model/response_result.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'package:domain/service/ssh_service.dart';
import 'package:domain/model/ssh/systemctl_command.dart';

class SshServiceImpl implements SshService {
    late final SshClientServiceImpl _sshClientService;

    static SshServiceImpl? _instance;

    SshServiceImpl._internal(this._sshClientService);

    factory SshServiceImpl(SshClientServiceImpl service) {
        _instance ??= SshServiceImpl._internal(service);
        return _instance!;
    }

    String? _password;

    /// Which connection the cached password was accepted for. A password is only
    /// ever reused on the exact profile that accepted it, so switching servers
    /// can never send it somewhere else.
    String? _passwordProfileKey;

    String? get _currentProfileKey {
        final profile = _sshClientService.getProfile();
        if (profile == null) {
            return null;
        }
        return '${profile.user}@${profile.url}:${profile.port}';
    }

    String? get _cachedPassword {
        final profileKey = _currentProfileKey;
        if (_password == null) {
            return null;
        }
        if (profileKey == null || profileKey != _passwordProfileKey) {
            clearCachedCredentials();
            return null;
        }
        return _password;
    }

    void _cachePassword(String password) {
        final profileKey = _currentProfileKey;
        if (profileKey == null) {
            return;
        }
        _password = password;
        _passwordProfileKey = profileKey;
    }

    @override
    void clearCachedCredentials() {
        _password = null;
        _passwordProfileKey = null;
    }

    @override
    Future<ResponseResult<bool>> systemCtlCommand({
        required SystemctlCommand command,
        required String service
    }) async {
        final client = _sshClientService.getClient();
        final String fullCommand = "sudo systemctl ${command.command} $service";
        if (kDebugMode) {
            if (client == null) { print("client is null"); }
            print("Run: $fullCommand");
        }
        final SSHSession? session = await client?.execute(fullCommand);
        await session?.done;
        if (session != null) {
            final int? exitCode = session.exitCode;
            final SSHSessionExitSignal? exitSignal = session.exitSignal;
            final stdoutStr = await session.stdout.decodeUtf8();
            final stderrStr = await session.stderr.decodeUtf8();

            if (kDebugMode) {
                print("stdout: $stdoutStr");
                print("stderr: $stderrStr");
                print("Command exited with code: $exitCode");
                print("Command exited with signal: ${exitSignal?.signalName}, message: ${exitSignal?.errorMessage}");
            }

            switch (exitCode) {
                case 0:
                    return ResponseSucceed(true);
                case 1: {
                    try {
                        if (_sshClientService.onPasswordRequest == null) {
                            if (kDebugMode) {
                                print("Password request callback not defined");
                            }
                            return ResponseFailed(error: "Password request callback not defined");
                        }

                        final cached = _cachedPassword;
                        if (cached == null) {
                            final passwordRequestResponse = await _sshClientService.onPasswordRequest!();
                            if (passwordRequestResponse == null) {
                                return ResponseFailed(error: "Password is null");
                            }
                            return await _runSudoCommand(passwordRequestResponse.password, fullCommand, passwordRequestResponse.remember);
                        }
                        else {
                            return await _runSudoCommand(cached, fullCommand, true);
                        }
                    } catch (error) {
                        return ResponseFailed(error: error.toString());
                    }
                }
                default:
                    return ResponseFailed(error: stderrStr);
            }
        }
        else {
            return ResponseFailed(error: "Session is null");
        }
    }

    Future<ResponseResult<bool>> _runSudoCommand(
        String password,
        String command,
        bool remember,
    ) async {
        final cleanPassword = password.trim();

        final sanitizedCommand = command.startsWith('sudo ')
            ? command.substring(5)
            : command;

        final result = await _runCommandWithStdin(
            "sudo -S $sanitizedCommand",
            utf8.encode('$cleanPassword\n'),
        );
        if (result is ResponseSucceed && remember) {
            _cachePassword(cleanPassword);
        }
        return result;
    }

    Future<ResponseResult<bool>> _runCommandWithStdin(
        String command,
        List<int> stdinBytes,
    ) async {
        final client = _sshClientService.getClient();
        if (kDebugMode) {
            print("Running over SSH: $command");
        }

        final SSHSession? session = await client?.execute(command);
        if (session == null) {
            return ResponseFailed(error: "SSH session is null");
        }

        final stdoutFuture = session.stdout.decodeUtf8();
        final stderrFuture = session.stderr.decodeUtf8();

        if (stdinBytes.isNotEmpty) {
            session.stdin.add(Uint8List.fromList(stdinBytes));
        }
        await session.stdin.close();
        await session.done;

        final exitCode = session.exitCode;
        final stdoutStr = await stdoutFuture;
        final stderrStr = await stderrFuture;

        if (kDebugMode) {
            print("stdout: $stdoutStr");
            print("stderr: $stderrStr");
            print("Exit code: $exitCode");
        }

        if (exitCode == 0) {
            return ResponseSucceed(true);
        }
        return ResponseFailed(
            error: stderrStr.isNotEmpty ? stderrStr : 'Command failed with exit code $exitCode',
        );
    }

    Future<ResponseResult<_SudoAuth>> _resolveSudoAuth() async {
        final cached = _cachedPassword;
        if (cached != null) {
            return ResponseSucceed(_SudoAuth(password: cached, remember: true));
        }

        final passwordless = await _runCommandWithStdin('sudo -n true', const []);
        if (passwordless is ResponseSucceed) {
            return ResponseSucceed(const _SudoAuth(password: null, remember: false));
        }

        if (_sshClientService.onPasswordRequest == null) {
            if (kDebugMode) {
                print("Password request callback not defined");
            }
            return ResponseFailed(error: "Password request callback not defined");
        }

        final passwordRequestResponse = await _sshClientService.onPasswordRequest!();
        if (passwordRequestResponse == null) {
            return ResponseFailed(error: "Password is required to write the file");
        }

        return ResponseSucceed(_SudoAuth(
            password: passwordRequestResponse.password.trim(),
            remember: passwordRequestResponse.remember,
        ));
    }

    String _quoteShellArg(String value) {
        return "'${value.replaceAll("'", r"'\''")}'";
    }

    /// Moves the staged file into place as root.
    ///
    /// An existing file keeps the owner, group and mode it already had: those are
    /// the administrator's choice, and a root owned `authorized_keys` is a
    /// deliberate hardening step that must survive an edit. Only a file this
    /// created gets `0600` and the login user as owner.
    String _privilegedInstallCommand({
        required String directory,
        required String stagingPath,
        required String filePath,
        required String? owner,
    }) {
        const script = r'''
set -e
directory=$1
staging=$2
target=$3
owner=$4
if [ ! -d "$directory" ]; then
    mkdir -p "$directory"
    chmod 700 "$directory"
    [ -z "$owner" ] || chown "$owner" "$directory"
fi
if [ -e "$target" ]; then
    mode=$(stat -c %a "$target" 2>/dev/null || stat -f %Lp "$target")
    ownership=$(stat -c %U:%G "$target" 2>/dev/null || stat -f %Su:%Sg "$target")
    mv "$staging" "$target"
    chmod "$mode" "$target"
    chown "$ownership" "$target"
else
    mv "$staging" "$target"
    chmod 600 "$target"
    [ -z "$owner" ] || chown "$owner" "$target"
fi
''';

        final ownerArg = (owner == null || owner.isEmpty)
            ? "''"
            : _quoteShellArg(owner);
        return 'sh -c ${_quoteShellArg(script)} sh '
            '${_quoteShellArg(directory)} ${_quoteShellArg(stagingPath)} '
            '${_quoteShellArg(filePath)} $ownerArg';
    }

    /// Creates an empty file for staging, letting `mktemp` pick the name so it
    /// cannot be guessed or pre-created as a symlink by another local user.
    /// Preferred location is the target directory, where the final move is a
    /// rename on the same filesystem rather than a copy.
    Future<ResponseResult<String>> _createStagingFile(String directory) async {
        final template = _quoteShellArg(
            p.posix.join(directory, '.moino-staging-XXXXXX'),
        );
        // The explicit template works the same on GNU and BSD mktemp, unlike -t.
        final result = await executeCommand(
            'umask 077; mktemp $template 2>/dev/null '
            r'|| mktemp "${TMPDIR:-/tmp}/moino-staging-XXXXXX"',
        );

        switch (result) {
            case ResponseFailed(error: final error):
                return ResponseFailed(error: 'Could not create a staging file: $error');
            case ResponseSucceed(data: final path):
                final stagingPath = path.trim();
                if (stagingPath.isEmpty ||
                    !p.posix.isAbsolute(stagingPath) ||
                    stagingPath.contains(RegExp(r'\s'))) {
                    return ResponseFailed(
                        error: 'Could not create a staging file on the remote',
                    );
                }
                return ResponseSucceed(stagingPath);
        }
    }

    @override
    Future<ResponseResult<bool>> writeFileWithSudo({
        required String filePath,
        required String content,
    }) async {
        final directory = p.posix.dirname(filePath);
        final owner = _sshClientService.getProfile()?.user;
        final contentBytes = utf8.encode(content);

        final stagingResult = await _createStagingFile(directory);
        final String stagingPath;
        switch (stagingResult) {
            case ResponseFailed(error: final error):
                return ResponseFailed(error: error);
            case ResponseSucceed(data: final path):
                stagingPath = path;
        }

        final installCommand = _privilegedInstallCommand(
            directory: directory,
            stagingPath: stagingPath,
            filePath: filePath,
            owner: owner,
        );

        try {
            if (kDebugMode) {
                print('Staging ${contentBytes.length} bytes at $stagingPath');
            }

            final staged = await _runCommandWithStdin(
                'cat > ${_quoteShellArg(stagingPath)}',
                contentBytes,
            );
            if (staged is ResponseFailed) {
                await _runCommandWithStdin('rm -f ${_quoteShellArg(stagingPath)}', const []);
                return staged;
            }

            final authResult = await _resolveSudoAuth();
            final ResponseResult<bool> installed;
            switch (authResult) {
                case ResponseFailed(:final error):
                    installed = ResponseFailed(error: error);
                case ResponseSucceed(:final data):
                    final password = data.password;
                    if (password == null) {
                        installed = await _runCommandWithStdin('sudo $installCommand', const []);
                    } else {
                        installed = await _runSudoCommand(
                            password,
                            installCommand,
                            data.remember,
                        );
                    }
            }

            if (installed is ResponseFailed) {
                await _runCommandWithStdin('rm -f ${_quoteShellArg(stagingPath)}', const []);
            }
            return installed;
        } catch (error) {
            await _runCommandWithStdin('rm -f ${_quoteShellArg(stagingPath)}', const []);
            return ResponseFailed(error: error.toString());
        }
    }

    @override
    Future<bool> isServiceRunning(String service) async {
        final client = _sshClientService.getClient();
        final session = await client?.execute('systemctl is-active $service');
        if (session != null) {
            final output = await session.stdout.decodeUtf8();
            final status = output.trim();
            return status == 'active';
        }
        if (kDebugMode) { print("session is null"); }
        return false;
    }

    @override
    Future<ResponseResult<String>> executeCommand(String command) async {
        final client = _sshClientService.getClient();
        try {
            final session = await client?.execute(command);
            if (session == null) {
                return ResponseFailed(error: 'session is null!');
            }

            // Both streams have to be drained at the same time: waiting for one
            // before reading the other stalls on commands with a lot of output.
            final stdoutFuture = session.stdout.decodeUtf8(allowMalformed: true);
            final stderrFuture = session.stderr.decodeUtf8(allowMalformed: true);
            await session.done;

            final stdoutStr = (await stdoutFuture).trim();
            final stderrStr = await stderrFuture;
            final exitCode = session.exitCode;

            if (exitCode == 0) {
                return ResponseSucceed(stdoutStr);
            }
            return ResponseFailed(error: stderrStr.isNotEmpty ? stderrStr : 'Command failed with exit code $exitCode');
        } catch (e) {
            if (kDebugMode) { print('Error executing command: $e'); }
            return ResponseFailed(error: 'SSH command failed: $e');
        }
    }

    @override
    Future<ResponseResult<List<String>>> getServiceList() async {
        final client = _sshClientService.getClient();
        try {
            final session = await client?.execute('ls /etc/systemd/system');
            if (session != null) {
                final output = <int>[];

                // Collect stdout data
                await for (final data in session.stdout) {
                    output.addAll(data);
                }

                // Wait for the session to complete
                await session.done;

                // Convert byte data to string
                final result = String.fromCharCodes(output);

                // Parse and return lines, filtering out empty ones
                final services = result
                    .split('\n')
                    .map((line) => line.trim())
                    .where((line) => line.isNotEmpty)
                    .toList();

                if (kDebugMode) {
                    print("services found: $services");
                }

                return ResponseSucceed<List<String>>(services);
            }
            else {
                return ResponseFailed(error: 'session is null!');
            }
        } catch (e) {
            if (kDebugMode) { print('Error executing command: $e'); }
            return ResponseFailed(error: 'SSH command failed: $e');
        }
    }

}

class _SudoAuth {
    final String? password;
    final bool remember;

    const _SudoAuth({
        required this.password,
        required this.remember,
    });
}