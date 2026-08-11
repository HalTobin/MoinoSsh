import 'dart:async';

import 'package:domain/model/sftp/download_item.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../use_case/download_tracker_use_cases.dart';
import 'download_tracker_event.dart';
import 'download_tracker_state.dart';

class DownloadTrackerViewModel extends ChangeNotifier {

    DownloadTrackerViewModel({required DownloadTrackerUseCases downloadTrackerUseCases})
      : _useCases = downloadTrackerUseCases
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final DownloadTrackerUseCases _useCases;
    DownloadTrackerState _state = DownloadTrackerState();
    DownloadTrackerState get state => _state;

    final _uiEvent = StreamController<DownloadTrackerUiEvent>.broadcast();
    Stream<DownloadTrackerUiEvent> get uiEvent => _uiEvent.stream;

    StreamSubscription? _folderSubscription;

    Future<void> _init() async {
        _watchDownloadItems();
        notifyListeners();
    }

    Future<void> onEvent(DownloadTrackerEvent event) async {
        switch (event) {
            case CancelDownload():
                _cancelDownload(event.downloadSessionId);
            case ShowFile():
                await _showFile(event.item);
        }
    }

    void _watchDownloadItems() {
        _folderSubscription = _useCases.watchDownloadItemsUseCase.execute().listen((items) {
            _state = _state.copyWith(items: items);
            notifyListeners();
        });
    }

    Future<void> _cancelDownload(int downloadSessionId) async {
        _useCases.cancelDownloadUseCase.execute(downloadSessionId);
    }

    Future<void> _showFile(DownloadItem item) async {
        switch (item.origin) {
            case DownloadOrigin.remote:
                final revealed = await _useCases.revealLocalFileUseCase.execute(
                    item.targetPath,
                );
                if (!revealed) {
                    _uiEvent.add(
                        ShowFileFailed(message: 'File no longer available'),
                    );
                }
            case DownloadOrigin.local:
                final folderPath = p.posix.dirname(item.targetPath);
                _uiEvent.add(OpenRemoteFileLocation(folderPath: folderPath));
        }
    }

    @override
    void dispose() {
        _folderSubscription?.cancel();
        _uiEvent.close();
        super.dispose();
    }

    static final String tag = "DownloadTrackerViewModel";

}
