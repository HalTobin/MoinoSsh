import 'package:domain/model/sftp/download_item.dart';
import 'package:domain/service/sftp_service.dart';

class WatchPendingDownloadUseCase {
    final SftpService sftpService;

    const WatchPendingDownloadUseCase({
        required this.sftpService
    });

    Stream<DownloadStatus> execute() {
        return sftpService.downloadTasksStream.map((tasks) {
            if (tasks.isEmpty) {
                return DownloadStatus.none;
            }
            final hasOngoing = tasks.any((task) => task.state is Downloading);
            if (hasOngoing) {
                return DownloadStatus.ongoing;
            }
            final hasFailed = tasks.any((task) => task.state is DownloadFailed);
            if (hasFailed) {
                return DownloadStatus.failed;
            }
            return DownloadStatus.complete;
        });
    }
}

enum DownloadStatus {
    ongoing,
    complete,
    failed,
    none
}