import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_client_service.dart';

class SshLogOutUseCase {
    SshLogOutUseCase({
        required SshClientService sshClientService,
        required SftpService sftpService,
    }) : _sshClientService = sshClientService,
         _sftpService = sftpService;

    final SshClientService _sshClientService;
    final SftpService _sftpService;

    Future<void> execute() async {
        // The SFTP session lives on the SSH connection, so it has to go with it.
        await _sftpService.closeSession();
        await _sshClientService.logOut();
    }
}
