import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:domain/service/ssh_client_service.dart';
import 'package:flutter/foundation.dart';

class SshClientServiceImpl implements SshClientService {
    SSHClient? _client;

    final StreamController<SshProfile?> _profileController = StreamController<SshProfile?>.broadcast();

    SshProfile? profile;

    SSHClient? getClient() {
        return _client;
    }

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

            profile = SshProfile(
                url: serverUrl,
                port: serverPort,
                user: user
            );

            _profileController.add(profile);
            return ConnectionSucceed();
        } catch (e) {
            if (kDebugMode) {
                print('SSH connection failed: $e');
            }
            _profileController.add(null);
            return ConnectionFailed(error: e.toString());
        }
    }

    @override
    Future<void> logOut() async {
        profile = null;
        _client?.close();
        _client = null;
        _profileController.add(null);
    }

    @override
    SshProfile? getProfile() {
        return profile;
    }

    @override
    Stream<SshProfile?> watchProfile() {
        return _profileController.stream;
    }

    void dispose() {
        _profileController.close();
    }

}