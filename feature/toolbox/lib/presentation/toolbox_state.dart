import 'package:ui/state/omit.dart';

import '../use_case/watch_pending_download_use_case.dart';

class ToolboxState {
    final DownloadStatus downloadStatus;

    ToolboxState({
        this.downloadStatus = DownloadStatus.none
    });

    ToolboxState copyWith({
        Defaulted<DownloadStatus> downloadStatus = const Omit()
    }) {
        return ToolboxState(
            downloadStatus: downloadStatus is Omit ? this.downloadStatus : downloadStatus as DownloadStatus
        );
    }

}