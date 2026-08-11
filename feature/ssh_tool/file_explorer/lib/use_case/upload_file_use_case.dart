import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class UploadFileUseCase {
    final SftpService sftpService;

    const UploadFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String localFile, String remoteTargetPath) async {
        final String fileName = p.basename(localFile);
        if (fileName.isEmpty) {
            if (kDebugMode) print('File name is empty');
            return false;
        }

        final String targetPath = remoteTargetPath.endsWith('/')
            ? '$remoteTargetPath$fileName'
            : '$remoteTargetPath/$fileName';

        return await sftpService.uploadFile(localFile, targetPath);
    }

}
