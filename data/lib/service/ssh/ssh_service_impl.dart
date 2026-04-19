import 'dart:convert';
import 'dart:io';

import 'utils/byte_decoder.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:domain/model/response_result.dart';
import 'package:flutter/foundation.dart';

import 'package:domain/service/ssh_service.dart';
import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:domain/model/ssh/systemctl_command.dart';

class SshServiceImpl extends ChangeNotifier implements ValueListenable<bool>, SshService {
    SSHClient? _client;
    SshProfile? _profile;

    static final SshServiceImpl _instance = SshServiceImpl._internal();
    factory SshServiceImpl() => _instance;

    SshServiceImpl._internal();

    bool _isConnected = false;

    String? _password = null;

    @override
    bool get value => _isConnected;

    @override
    Future<PasswordCallbackResponse?> Function()? onPasswordRequest;

    @override
    void setOnPasswordRequestCallback(Future<PasswordCallbackResponse?> Function() callback) {
        onPasswordRequest = callback;
    }

    @override
    Future<ConnectionStatus> connect({
        required String user,
        required String serverUrl,
        required String serverPort,
        required String sshFilePath,
        required String? password
    }) async {
        try {
            if (kDebugMode) {
                print('SSH connecting to: $user@$serverUrl:$serverPort');
            }

            final port = int.tryParse(serverPort) ?? 22;
            final key = File(sshFilePath).readAsStringSync();
            final socket = await SSHSocket.connect(serverUrl, port);
            _client = SSHClient(
                socket,
                username: user,
                identities: [
                    ...SSHKeyPair.fromPem(key, password)
                ]
            );

            _profile = SshProfile(
                url: serverUrl,
                port: serverPort,
                user: user
            );

            _updateConnectionState(true);
            return ConnectionSucceed();
        } catch (e) {
            if (kDebugMode) {
                print('SSH connection failed: $e');
            }
            _updateConnectionState(false);
            return ConnectionFailed(error: e.toString());
        }
    }

    @override
    Future<ResponseResult<bool>> systemCtlCommand({
        required SystemctlCommand command,
        required String service
    }) async {
        final String fullCommand = "sudo systemctl ${command.command} $service";
        if (kDebugMode) {
            if (_client == null) { print("_client is null"); }
            print("Run: $fullCommand");
        }
        final SSHSession? session = await _client?.execute(fullCommand);
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
                        if (onPasswordRequest == null) {
                            if (kDebugMode) {
                                print("Password request callback not defined");
                            }
                            return ResponseFailed(error: "Password request callback not defined");
                        }

                        if (_password == null) {
                            final passwordRequestResponse = await onPasswordRequest!();
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

    Future<ResponseResult<bool>> _runSudoCommand(String password, String command, bool remember) async {
        final cleanPassword = password.trim();

        final sanitizedCommand = command.startsWith('sudo ')
            ? command.substring(5)
            : command;

        final sudoCommand = "sudo -S $sanitizedCommand";
        if (kDebugMode) {
            print("Running over SSH: $sudoCommand");
        }

        final SSHSession? session = await _client?.execute(sudoCommand);
        if (session == null) {
            return ResponseFailed(error: "SSH session is null");
        }

        session.stdin.add(utf8.encode('$cleanPassword\n'));
        await session.stdin.close();

        await session.done;

        final exitCode = session.exitCode;
        final stdoutStr = await session.stdout.decodeUtf8();
        final stderrStr = await session.stderr.decodeUtf8();

        if (kDebugMode) {
            print("stdout: $stdoutStr");
            print("stderr: $stderrStr");
            print("Exit code: $exitCode");
        }

        if (exitCode == 0) {
            if (remember) {
                _password = cleanPassword;
            }
            return ResponseSucceed(true);
        } else {
            return ResponseFailed(error: stderrStr);
        }
    }

    @override
    Future<bool> isServiceRunning(String service) async {
        final session = await _client?.execute('systemctl is-active $service');
        if (session != null) {
            final output = await session.stdout.decodeUtf8();
            final status = output.trim();
            return status == 'active';
        }
        if (kDebugMode) { print("session is null"); }
        return false;
    }

    @override
    Future<ResponseResult<List<String>>> getServiceList() async {
        try {
            final session = await _client?.execute('ls /etc/systemd/system');
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

    @override
    Future<void> logout() async {
        _profile = null;
        _client?.close();
        _client = null;
        _sftpClient?.close();
        _sftpClient = null;
        _password = null;
        _updateConnectionState(false);
    }

    void _updateConnectionState(bool state) {
        if (state != _isConnected) {
            if (kDebugMode) {
                print("Connection state: $state");
            }
            _isConnected = state;
            notifyListeners();
        }
    }

    @override
    void fakeConnect() async {
        _updateConnectionState(true);
    }

    @override
    SshProfile? getCurrentProfile() { return _profile; }

}