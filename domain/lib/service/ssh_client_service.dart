import 'package:domain/model/ssh/connection_status.dart';

import '../model/ssh/ssh_profile.dart';

abstract interface class SshClientService {

    Future<PasswordCallbackResponse?> Function()? onPasswordRequest;

    void setOnPasswordRequestCallback(Future<PasswordCallbackResponse?> Function() callback) {
        onPasswordRequest = callback;
    }

    Future<ConnectionStatus> connect(
        {
          required String user,
          required String serverUrl,
          required String serverPort,
          required String sshFilePath,
          required String? password
        }
    );

    Future<void> logOut();

    SshProfile? getProfile();

    Stream<SshProfile?> watchProfile();

}

class PasswordCallbackResponse {
    final String password;
    final bool remember;

    const PasswordCallbackResponse({
        required this.password,
        required this.remember
    });
}