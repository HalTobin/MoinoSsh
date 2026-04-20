import 'package:domain/service/ssh_client_service.dart';

class SetOnPasswordRequestUseCase {
    final SshClientService sshClientService;

    const SetOnPasswordRequestUseCase({required this.sshClientService});

    void execute(Future<PasswordCallbackResponse?> Function() callback) {
        sshClientService.onPasswordRequest = callback;
    }
}