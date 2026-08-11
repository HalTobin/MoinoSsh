import 'cancel_download_use_case.dart';
import 'reveal_local_file_use_case.dart';
import 'watch_download_items_use_case.dart';

class DownloadTrackerUseCases {
    final CancelDownloadUseCase cancelDownloadUseCase;
    final WatchDownloadItemsUseCase watchDownloadItemsUseCase;
    final RevealLocalFileUseCase revealLocalFileUseCase;

    DownloadTrackerUseCases({
        required this.cancelDownloadUseCase,
        required this.watchDownloadItemsUseCase,
        required this.revealLocalFileUseCase,
    });
}
