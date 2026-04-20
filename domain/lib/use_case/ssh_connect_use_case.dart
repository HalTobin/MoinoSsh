import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/service/ssh_client_service.dart';

class SshConnectUseCase {
    SshConnectUseCase({
        required SshClientService sshClientService
    })
        : _sshClientService = sshClientService;

    final SshClientService _sshClientService;

    Future<ConnectionStatus> execute(SshConnectRequest request) async {
        final String serverUrl = request.url;
        final String serverPort = request.port;
        final String user = request.user;
        final String sshFilePath = request.filePath;
        final String? password = request.password;

        return await _sshClientService.connect(
            user: user,
            serverUrl: serverUrl,
            serverPort: serverPort,
            sshFilePath: sshFilePath,
            password: password
        );
    }
}

class SshConnectRequest {
    final String user;
    final String url;
    final String port;
    final String filePath;
    final String? password;

    SshConnectRequest({
        required this.user,
        required this.url,
        required this.port,
        required this.filePath,
        required this.password
    });
}