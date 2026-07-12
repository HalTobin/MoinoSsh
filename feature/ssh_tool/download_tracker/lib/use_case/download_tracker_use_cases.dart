import 'watch_download_items_use_case.dart';
import 'cancel_download_use_case.dart';

class DownloadTrackerUseCases {
    final WatchDownloadItemsUseCase watchDownloadItemsUseCase;
    final CancelDownloadUseCase cancelDownloadUseCase;

    DownloadTrackerUseCases({
        required this.watchDownloadItemsUseCase,
        required this.cancelDownloadUseCase
    });
}