import 'package:domain/service/sftp_service.dart';

class WriteFileContentUseCase {
  final SftpService sftpService;

  const WriteFileContentUseCase({
    required this.sftpService
  });

  Future<bool> execute(String filePath, String content) async {
    return await sftpService.writeStringFile(filePath, content);
  }

}