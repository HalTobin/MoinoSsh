import 'package:flutter/foundation.dart';

import '../model/ssh/connection_status.dart';
import '../model/response_result.dart';
import '../model/ssh/ssh_profile.dart';
import '../model/ssh/systemctl_command.dart';

abstract interface class SshService extends ChangeNotifier implements ValueListenable<bool> {

    Future<PasswordCallbackResponse?> Function()? onPasswordRequest;

    void setOnPasswordRequestCallback(Future<PasswordCallbackResponse?> Function() callback) {
        onPasswordRequest = callback;
    }

    Future<ConnectionStatus> connect({
        required String user,
        required String serverUrl,
        required String serverPort,
        required String sshFilePath,
        required String? password
    });

    Future<ResponseResult<bool>> systemCtlCommand({
        required SystemctlCommand command,
        required String service
    });

    Future<bool> isServiceRunning(String service);

    Future<ResponseResult<List<String>>> getServiceList();

    Future<void> logout();

    void fakeConnect();

    SshProfile? getCurrentProfile();

    void closeSftp();

}

class PasswordCallbackResponse {
    final String password;
    final bool remember;

    const PasswordCallbackResponse({
        required this.password,
        required this.remember
    });
}