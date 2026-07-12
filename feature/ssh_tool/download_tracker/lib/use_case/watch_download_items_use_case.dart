import 'package:domain/model/sftp/download_item.dart';
import 'package:domain/service/sftp_service.dart';

class WatchDownloadItemsUseCase {
    final SftpService sftpService;

    const WatchDownloadItemsUseCase({
        required this.sftpService
    });

    Stream<List<DownloadItem>> execute() async* {
        yield sftpService.currentDownloadTasks;
        yield* sftpService.downloadTasksStream;
    }

}