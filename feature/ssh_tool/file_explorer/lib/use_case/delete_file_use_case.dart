import 'package:domain/service/sftp_service.dart';

class DeleteFileUseCase {
    final SftpService sftpService;

    const DeleteFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String filePath) async {
        return await sftpService.delete(filePath);
    }

}