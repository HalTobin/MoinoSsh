sealed class DownloadTrackerEvent {}

class CancelDownload extends DownloadTrackerEvent {
    final int downloadSessionId;

    CancelDownload({required this.downloadSessionId});
}