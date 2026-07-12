import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';

class UploadFileUseCase {
    final SftpService sftpService;

    const UploadFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String localFile, String remoteTargetPath) async {
        final String? fileName = localFile.split("/").lastOrNull;
        if (fileName != null) {
            final String targetPath = remoteTargetPath.endsWith('/')
                ? '$remoteTargetPath$fileName'
                : '$remoteTargetPath/$fileName';

            return await sftpService.uploadFile(localFile, targetPath);
        }
        else {
            if (kDebugMode) print("File name is null");
            return false;
        }
    }

}