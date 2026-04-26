import 'package:domain/service/sftp_service.dart';

class ReadFileAsTextUseCase {
    final SftpService sftpService;

    const ReadFileAsTextUseCase({required this.sftpService});

    Future<String?> execute(String filePath) async {
        return sftpService.readFileAsString(filePath);
    }

}