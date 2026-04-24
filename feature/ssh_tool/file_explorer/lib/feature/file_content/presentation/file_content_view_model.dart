import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'file_content_state.dart';

class FileContentViewModel extends ChangeNotifier {

    FileContentViewModel({required FileContentUseCases fileContentUseCase})
      : _useCases = fileContentUseCase
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final FileContentUseCases _useCases;
    FileContentState _state = FileContentState();
    FileContentState get state => _state;

    Future<void> _init() async {

    }

    static final String tag = "FileContentViewModel";

}