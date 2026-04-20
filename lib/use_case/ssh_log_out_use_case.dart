import 'package:domain/service/ssh_client_service.dart';

class SshLogOutUseCase {
    SshLogOutUseCase({required SshClientService sshClientService})
      : _sshClientService = sshClientService;

    final SshClientService _sshClientService;

    Future<void> execute() async {
        _sshClientService.logOut();
    }
}