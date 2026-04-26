import 'package:feature_file_explorer/feature/file_content/presentation/file_content_event.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:flutter/foundation.dart';

import 'file_content_state.dart';

class FileContentViewModel extends ChangeNotifier {
    final String filePath;

    FileContentViewModel({
        required FileContentUseCases fileContentUseCase,
        required this.filePath
    })
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
        final fileName = _useCases.getFileNameFromPathUseCase.execute(filePath);
        _state = _state.copyWith(fileName: fileName ?? "Error", filePath: filePath);
        _loadFile(filePath);
    }

    Future<void> _loadFile(String path) async {
        final String? text = await _useCases.readFileAsTextUseCase.execute(path);
        _state = _state.copyWith(content: text);
        notifyListeners();
    }

    Future<void> onEvent(FileContentEvent event) async {
        switch (event) {
            case FilterContentEvent():
                _filterContent(event.filter);
            case SearchContentEvent():
                _searchContent(event.search);
        }
    }

    Future<void> _filterContent(String? filter) async {

    }

    Future<void> _searchContent(String? search) async {
        _state = _state.copyWith(searchQuery: search);
        notifyListeners();
    }

    static final String tag = "FileContentViewModel";

}