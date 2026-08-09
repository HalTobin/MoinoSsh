import 'package:domain/model/image_file.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';

class LoadImageBytesUseCase {
    final SftpService sftpService;

    const LoadImageBytesUseCase({required this.sftpService});

    Future<ImageFile?> execute(String filePath) async {
        final file = await sftpService.readFileAsBytes(filePath);
        if (file == null) {
            if (kDebugMode) {
                print("[$_tag] file is null at: $filePath");
            }
            return null;
        }

        return file;
    }

    static final String _tag = "LoadImageBytesUseCase";
}
