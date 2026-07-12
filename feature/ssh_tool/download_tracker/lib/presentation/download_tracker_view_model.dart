import 'dart:async';
import 'package:flutter/foundation.dart';

import '../use_case/download_tracker_use_cases.dart';
import 'download_tracker_state.dart';
import 'download_tracker_event.dart';

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

    StreamSubscription? _folderSubscription;

    Future<void> _init() async {
        _watchDownloadItems();
        notifyListeners();
    }

    Future<void> onEvent(DownloadTrackerEvent event) async {
        switch (event) {
            case CancelDownload():
                _cancelDownload(event.downloadSessionId);
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

    @override
    void dispose() {
        _folderSubscription?.cancel();
        super.dispose();
    }

    static final String tag = "DownloadTrackerViewModel";

}