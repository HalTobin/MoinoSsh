import 'package:domain/service/ssh_service.dart';

class CloseSftpUseCase {
    final SshService sshService;

    const CloseSftpUseCase({
        required this.sshService
    });

    void execute() {
        sshService.closeSftp();
    }
}