import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/foundation.dart';

import '../data/navigation_result.dart';
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
        _watchFolders();
        notifyListeners();
        final showHidden = await _useCases.checkDefaultShowHiddenUseCase.execute();
        _state = _state.copyWith(showHidden: showHidden);
        notifyListeners();
        await _navigateRoot();
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

    Future<void> _watchFolders() async {
        await _folderSubscription?.cancel();
        final folderWatcher = await _useCases.watchFoldersUseCase.execute();
        _folderSubscription = folderWatcher.listen((folders) {
            if (kDebugMode) {
                final folderNames = folders.map((folder) => folder.path)
                    .toList();
                print("[$tag] Folders changed: $folderNames");
            }
            final bool isPinned = folders.any((folder) => folder.path == _state.currentPath);
            _state = _state.copyWith(
                isPinned: isPinned,
                pinnedFolders: folders
            );
            notifyListeners();
        });
    }

    Future<void> _openFolder(String path) async {
        setLoading(true);
        final result = await _useCases.navigateToFolderUseCase.execute(path);
        _handleNavigateResult(result, path);
    }

    Future<void> _selectFile(String path) async {
        //TODO()
        throw UnimplementedError();
    }

    Future<void> _navigateRoot() async {
        setLoading(true);
        final result = await _useCases.navigateToRootUseCase.execute();
        _handleNavigateResult(result, "/");
    }

    Future<void> _navigateUp() async {
        setLoading(true);
        final result = await _useCases.navigateUpUseCase.execute(_state.currentPath);
        _handleNavigateResult(result, p.dirname(_state.currentPath));
    }

    Future<void> _handleNavigateResult(NavigationResult? result, String requestedPath) async {
        if (result != null) {
            _state = _state.copyWith(
                loading: false,
                currentPath: result.destinationPath,
                files: result.content,
                isPinned: result.isPinned
            );
        }
        else {
            _setError("Couldn't navigate to $requestedPath");
        }
        notifyListeners();
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

    void setLoading(bool loading) {
        _state = _state.copyWith(loading: loading);
        notifyListeners();
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