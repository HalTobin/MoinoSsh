import 'package:domain/service/sftp_service.dart';
import 'package:domain/service/ssh_client_service.dart';
import 'package:domain/service/ssh_service.dart';

class SshLogOutUseCase {
    SshLogOutUseCase({
        required SshClientService sshClientService,
        required SftpService sftpService,
        required SshService sshService,
    }) : _sshClientService = sshClientService,
         _sftpService = sftpService,
         _sshService = sshService;

    final SshClientService _sshClientService;
    final SftpService _sftpService;
    final SshService _sshService;

    Future<void> execute() async {
        // The SFTP session lives on the SSH connection, so it has to go with it,
        // and the sudo password must not outlive the connection that accepted it.
        await _sftpService.closeSession();
        _sshService.clearCachedCredentials();
        await _sshClientService.logOut();
    }
}
