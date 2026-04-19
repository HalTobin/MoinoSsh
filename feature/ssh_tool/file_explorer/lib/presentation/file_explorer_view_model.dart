import 'dart:async';

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

    StreamSubscription? _folderSubscription;

    Future<void> _init() async {
        _state = _state.copyWith(loading: true);
        notifyListeners();
        final showHidden = await _useCases.checkDefaultShowHiddenUseCase.execute();
        _state = _state.copyWith(showHidden: showHidden);
        notifyListeners();
    }

    Future<void> onEvent(FileExplorerEvent event) async {
        switch (event) {
            case OpenFolder():
                _openFolder(event.folderPath);
            case SelectFile():
                _selectFile(event.filePath);
            case NavigateRootEvent():
                _navigateRoot();
            case NavigateUpEvent():
                _navigateUp();
            case ToggleHiddenEvent():
                _toggleHidden();
            case PinUnpinEvent():
                _pinUnpinFolder();
            case RenamePinnedFolder():
                _renamePinnedFolder(event.newAlias);
        }
    }

    Future<void> _watchFolder(String path) async {
        await _folderSubscription?.cancel();
        final folderWatcher = await _useCases.watchFolderUseCase.execute(path);
        _folderSubscription = folderWatcher.listen((folder) {
            final bool isPinned = folder != null;
            _state = _state.copyWith(isPinned: isPinned);
            notifyListeners();
        });
    }

    Future<void> _openFolder(String path) async {
        final result = await _useCases.listFolderContentUseCase.execute(path);
        _state = _state.copyWith(
            currentPath: result.destinationPath,
            files: result.content
        );
        notifyListeners();
        await _watchFolder(result.destinationPath);
    }

    Future<void> _selectFile(String path) async {
        //TODO()
        throw UnimplementedError();
    }

    Future<void> _navigateRoot() async {
        final result = await _useCases.navigateToRootUseCase.execute();
        _state = _state.copyWith(
            currentPath: result.destinationPath,
            files: result.content
        );
        notifyListeners();
        await _watchFolder(result.destinationPath);
    }

    Future<void> _navigateUp() async {
        final result = await _useCases.navigateUpUseCase.execute(_state.currentPath);
        _state = _state.copyWith(
            currentPath: result.destinationPath,
            files: result.content
        );
        notifyListeners();
        await _watchFolder(result.destinationPath);
    }

    Future<void> _toggleHidden() async {
        _state = _state.copyWith(showHidden: !_state.showHidden);
        notifyListeners();
    }

    Future<void> _pinUnpinFolder() async {
        await _useCases.pinUnpinDirectoryUseCase.execute(_state.currentPath);
        notifyListeners();
    }

    Future<void> _renamePinnedFolder(String newAlias) async {
        await _useCases.renamePinnedFolderUseCase.execute(_state.currentPath, newAlias);
    }

    void _setError(String error) {
        _state = _state.copyWith(error: error);
        notifyListeners();
    }

    @override
    void dispose() {
        _folderSubscription?.cancel();
        super.dispose();
    }

    static final String tag = "FileExplorerViewModel";

}