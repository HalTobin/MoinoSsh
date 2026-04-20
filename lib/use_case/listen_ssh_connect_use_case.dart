import 'package:domain/service/ssh_client_service.dart';

class ListenSshConnectUseCase {
    ListenSshConnectUseCase({required SshClientService sshClientService})
      : _sshClientService = sshClientService;

    final SshClientService _sshClientService;

    Stream<bool> execute() {
        return _sshClientService.watchProfile()
            .map((profile) => profile != null);
    }
}