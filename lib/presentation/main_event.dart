import 'package:domain/service/ssh_service.dart';

sealed class MainEvent {}

class SshLogOut extends MainEvent {}

class SetOnPasswordRequest extends MainEvent {
    final Future<PasswordCallbackResponse?> Function() onPasswordRequest;
    SetOnPasswordRequest({required this.onPasswordRequest});
}

class SaveSshUserPassword extends MainEvent {
    final String password;
    SaveSshUserPassword({required this.password});
}