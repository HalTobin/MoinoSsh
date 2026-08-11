import 'package:domain/model/sftp/download_item.dart';

sealed class DownloadTrackerEvent {}

class CancelDownload extends DownloadTrackerEvent {
    final int downloadSessionId;

    CancelDownload({required this.downloadSessionId});
}

class ShowFile extends DownloadTrackerEvent {
    final DownloadItem item;

    ShowFile({required this.item});
}

sealed class DownloadTrackerUiEvent {}

class OpenRemoteFileLocation extends DownloadTrackerUiEvent {
    final String folderPath;

    OpenRemoteFileLocation({required this.folderPath});
}
