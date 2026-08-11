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

sealed class DownloadState {
  const DownloadState();

  int get transferredBytes;
  double get bytesPerSecond => 0;
}

class DownloadFailed extends DownloadState {
  @override
  final int transferredBytes;

  const DownloadFailed({this.transferredBytes = 0});
}

class DownloadCanceled extends DownloadState {
  @override
  final int transferredBytes;

  const DownloadCanceled({this.transferredBytes = 0});
}

class DownloadCompleted extends DownloadState {
  @override
  final int transferredBytes;

  const DownloadCompleted({this.transferredBytes = 0});
}

class Downloading extends DownloadState {
  final double progress;
  final int downloadedBytes;
  @override
  final double bytesPerSecond;

  const Downloading({
    required this.progress,
    required this.downloadedBytes,
    this.bytesPerSecond = 0,
  });

  @override
  int get transferredBytes => downloadedBytes;
}
