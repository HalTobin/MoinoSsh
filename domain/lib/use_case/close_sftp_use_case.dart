import 'package:domain/service/sftp_service.dart';

class CloseSftpUseCase {
    final SftpService sftpService;

    const CloseSftpUseCase({
        required this.sftpService
    });

    void execute() {
        sftpService.closeSession();
    }
}