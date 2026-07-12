import 'package:domain/service/sftp_service.dart';

class RenameFileUseCase {
    final SftpService sftpService;

    const RenameFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String filePath, String newName) async {
        final String parentFolder = filePath.split("/").sublist(0, filePath.split("/").length - 1).join("/");
        final String destPath = "$parentFolder/${newName.trim()}";
        return await sftpService.rename(filePath, destPath);
    }

}