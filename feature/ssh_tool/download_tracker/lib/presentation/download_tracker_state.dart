import 'package:domain/model/sftp/download_item.dart';
import 'package:ui/state/omit.dart';

class DownloadTrackerState {
    final List<DownloadItem> items;

    DownloadTrackerState({
        this.items = const []
    });

    DownloadTrackerState copyWith({
        Defaulted<List<DownloadItem>> items = const Omit()
    }) {
        return DownloadTrackerState(
            items: items is Omit ? this.items : items as List<DownloadItem>
        );
    }
}