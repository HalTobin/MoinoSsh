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

    String? _password = null;

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

                        if (_password == null) {
                            final passwordRequestResponse = await _sshClientService.onPasswordRequest!();
                            if (passwordRequestResponse == null) {
                                return ResponseFailed(error: "Password is null");
                            }
                            return await _runSudoCommand(passwordRequestResponse.password, fullCommand, passwordRequestResponse.remember);
                        }
                        else {
                            return await _runSudoCommand(_password!, fullCommand, true);
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
            _password = cleanPassword;
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
        if (_password != null) {
            return ResponseSucceed(_SudoAuth(password: _password, remember: true));
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

    String _privilegedInstallCommand({
        required String directory,
        required String tempPath,
        required String filePath,
        required String? owner,
    }) {
        final ownerArg = (owner == null || owner.isEmpty)
            ? "''"
            : _quoteShellArg(owner);
        return 'sh -c \'mkdir -p "\$1" && mv "\$2" "\$3" && chmod 700 "\$1" && chmod 600 "\$3" && { [ -z "\$4" ] || chown "\$4" "\$1" "\$3"; }\' '
            'sh ${_quoteShellArg(directory)} ${_quoteShellArg(tempPath)} ${_quoteShellArg(filePath)} $ownerArg';
    }

    @override
    Future<ResponseResult<bool>> writeFileWithSudo({
        required String filePath,
        required String content,
    }) async {
        final directory = p.posix.dirname(filePath);
        final owner = _sshClientService.getProfile()?.user;
        final tempPath = '/tmp/moino-ak-${DateTime.now().microsecondsSinceEpoch}';
        final contentBytes = utf8.encode(content);
        final installCommand = _privilegedInstallCommand(
            directory: directory,
            tempPath: tempPath,
            filePath: filePath,
            owner: owner,
        );

        try {
            if (kDebugMode) {
                print('Staging ${contentBytes.length} bytes at $tempPath');
            }

            final staged = await _runCommandWithStdin(
                'umask 077; cat > ${_quoteShellArg(tempPath)}',
                contentBytes,
            );
            if (staged is ResponseFailed) {
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
                await _runCommandWithStdin('rm -f ${_quoteShellArg(tempPath)}', const []);
            }
            return installed;
        } catch (error) {
            await _runCommandWithStdin('rm -f ${_quoteShellArg(tempPath)}', const []);
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

            final output = <int>[];
            await for (final data in session.stdout) {
                output.addAll(data);
            }
            await session.done;

            final stdoutStr = String.fromCharCodes(output).trim();
            final stderrStr = await session.stderr.decodeUtf8();
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