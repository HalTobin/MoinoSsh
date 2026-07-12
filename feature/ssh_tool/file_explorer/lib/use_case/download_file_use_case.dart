import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';

class DownloadFileUseCase {
    final SftpService sftpService;

    const DownloadFileUseCase({
        required this.sftpService
    });

    Future<bool> execute(String remoteFile, String localTargetPath) async {
        final String? fileName = remoteFile.split("/").lastOrNull;
        if (fileName != null) {
            final String targetPath = "$localTargetPath/$fileName";
            return await sftpService.downloadFile(remoteFile, targetPath);
        }
        else {
            if (kDebugMode) print("File name is null");
            return false;
        }
    }

}