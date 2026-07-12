class DownloadItem {
  final int downloadSessionId;
  final String filePath;
  final String fileName;
  final String targetPath;
  final int size;
  final DownloadOrigin origin;
  final DownloadState state;

  DownloadItem({
    required this.downloadSessionId,
    required this.filePath,
    required this.fileName,
    required this.targetPath,
    required this.size,
    required this.origin,
    required this.state,
  });

  DownloadItem copyWith({DownloadState? state}) {
    return DownloadItem(
      downloadSessionId: downloadSessionId,
      filePath: filePath,
      fileName: fileName,
      targetPath: targetPath,
      size: size,
      origin: origin,
      state: state ?? this.state,
    );
  }
}

enum DownloadOrigin { local, remote }

sealed class DownloadState {}

class DownloadFailed extends DownloadState {}

class DownloadCanceled extends DownloadState {}

class DownloadCompleted extends DownloadState {}

class Downloading extends DownloadState {
  final double progress;
  final int downloadedBytes;

  Downloading({required this.progress, required this.downloadedBytes});
}