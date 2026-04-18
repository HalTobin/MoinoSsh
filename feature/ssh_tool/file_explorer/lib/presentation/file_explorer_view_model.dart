import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/foundation.dart';

import '../use_case/file_explorer_use_cases.dart';
import 'file_explorer_state.dart';

class FileExplorerViewModel extends ChangeNotifier {

    FileExplorerViewModel({required FileExplorerUseCases fileExplorerUseCases})
      : _useCases = fileExplorerUseCases
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final FileExplorerUseCases _useCases;
    FileExplorerState _state = FileExplorerState();
    FileExplorerState get state => _state;

    Future<void> _init() async {
        final showHidden = await _useCases.checkDefaultShowHiddenUseCase.execute();
        _state = _state.copyWith(showHidden: showHidden);
    }

    Future<void> onEvent(FileExplorerEvent event) async {
        switch (event) {
          case OpenFolder():
            _openFolder(event.folderPath);
          case SelectFile():
            _selectFile(event.filePath);
          case OpenFile():
            _openFile(event.filePath);
        }
    }

    Future<void> _openFolder(String path) async {
        // TODO()
        throw UnimplementedError();
    }

    Future<void> _selectFile(String path) async {
        //TODO()
        throw UnimplementedError();
    }

    Future<void> _openFile(String path) async {
        // TODO()
        throw UnimplementedError();
    }

    void _setError(String error) {
        _state = _state.copyWith(error: error);
        notifyListeners();
    }

    static final String tag = "FileExplorerViewModel";

}