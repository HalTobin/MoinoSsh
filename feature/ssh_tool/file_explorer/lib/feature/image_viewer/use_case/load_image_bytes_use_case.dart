import 'package:domain/model/text_file.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:flutter/foundation.dart';

class LoadImageBytesUseCase {
    final SftpService sftpService;

    const LoadImageBytesUseCase({required this.sftpService});

    Future<TextFile?> execute(String filePath) async {
        final file = await sftpService.readFileAsString(filePath);
        if (file == null) {
            if (kDebugMode) {
                print("[$_tag] file is null at: $filePath");
            }
            return null;
        }

        return file;
    }

    static final String _tag = "GetFileUseCase";

}