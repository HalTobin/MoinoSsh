import 'package:domain/service/sftp_service.dart';

class CreateFileUseCase {
    final SftpService sftpService;

    const CreateFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String parentPath, String newFileName) async {
        final String newFile = (parentPath.endsWith("/"))
            ? "$parentPath$newFileName"
            : "$parentPath/$newFileName";

        return await sftpService.createFile(newFile);
    }

}