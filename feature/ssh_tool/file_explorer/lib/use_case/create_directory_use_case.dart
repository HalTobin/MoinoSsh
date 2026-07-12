import 'package:domain/service/sftp_service.dart';

class CreateDirectoryUseCase {
    final SftpService sftpService;

    const CreateDirectoryUseCase({
        required this.sftpService
    });

    Future<bool> execute(String parentPath, String newFolderName) async {
        final String newFolder = (parentPath.endsWith("/"))
            ? "$parentPath$newFolderName"
            : "$parentPath/$newFolderName";

        return await sftpService.createDirectory(newFolder);
    }

}