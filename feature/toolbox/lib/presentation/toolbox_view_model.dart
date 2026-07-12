import 'dart:async';

import 'package:feature_toolbox/presentation/toolbox_state.dart';
import 'package:flutter/foundation.dart';

import '../use_case/toolbox_use_cases.dart';

class ToolboxViewModel extends ChangeNotifier {

    ToolboxViewModel({required ToolboxUseCases toolboxUseCases})
      : _useCases = toolboxUseCases
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final ToolboxUseCases _useCases;
    ToolboxState _state = ToolboxState();
    ToolboxState get state => _state;

    StreamSubscription? _downloadStatusSubscription;

    Future<void> _init() async {
        _watchDownloadStatus();
    }

    void _watchDownloadStatus() {
        _downloadStatusSubscription = _useCases.watchPendingDownloadUseCase.execute().listen((status) {
            _state = _state.copyWith(downloadStatus: status);
        });
    }

    static final String tag = "ToolboxViewModel";

}