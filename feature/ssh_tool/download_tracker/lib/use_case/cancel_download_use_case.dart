import 'package:domain/model/sftp/download_item.dart';
import 'package:domain/service/sftp_service.dart';

class CancelDownloadUseCase {
    final SftpService sftpService;

    const CancelDownloadUseCase({
        required this.sftpService
    });

    Future<void> execute(int downloadSessionId) async {
        return sftpService.cancelDownload(downloadSessionId);
    }

}