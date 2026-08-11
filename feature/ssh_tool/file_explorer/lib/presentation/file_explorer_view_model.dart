import 'dart:async';

import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:path/path.dart' as p;
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/foundation.dart';

import '../data/navigation_result.dart';
import '../use_case/file_explorer_use_cases.dart';
import 'file_explorer_state.dart';

class FileExplorerViewModel extends ChangeNotifier {

    FileExplorerViewModel({
        required FileExplorerUseCases fileExplorerUseCases,
        String? initialPath,
    }) : _useCases = fileExplorerUseCases,
         _initialPath = initialPath
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final FileExplorerUseCases _useCases;
    final String? _initialPath;
    FileExplorerState _state = FileExplorerState();
    FileExplorerState get state => _state;

    final _uiEvent = StreamController<FileExplorerUiEvent>();
    Stream<FileExplorerUiEvent> get uiEvent => _uiEvent.stream;

    StreamSubscription? _folderSubscription;

    Future<void> _init() async {
        _state = _state.copyWith(loading: true);
        _watchFolders();
        notifyListeners();
        final showHidden = await _useCases.checkDefaultShowHiddenUseCase.execute();
        final viewMode = await _useCases.getDefaultViewModeUseCase.execute();
        _state = _state.copyWith(showHidden: showHidden, viewMode: viewMode);
        notifyListeners();

        final initialPath = _initialPath?.trim();
        if (initialPath != null && initialPath.isNotEmpty) {
            await _openFolder(initialPath);
        } else {
            await _navigateRoot();
        }
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
            case SelectViewMode():
                _selectViewMode(event.viewMode);
            case PinUnpinEvent():
                _pinUnpinFolder(event.path);
            case RenamePinnedFolder():
                _renamePinnedFolder(path: event.path, newAlias: event.newAlias);
            case EditPinnedFolderIcon():
                _updatePinnedFolderIcon(path: event.path, newIcon: event.newIcon);
            case DeleteFile():
                _deleteFile(path: event.filePath);
            case RenameFile():
                _renameFile(filePath: event.filePath, newName: event.newName);
            case CreateFile():
                _createFile(fileName: event.fileName);
            case CreateFolder():
                _createFolder(folderName: event.folderName);
            case RefreshContent():
                _refreshContent();
            case DownloadFile():
                _downloadFile(remoteFilePath: event.remoteFilePath, localeTargetPath: event.localeTargetPath);
            case UploadFile():
                _uploadFiles(
                    localeFilePaths: event.localeFilePaths,
                    remoteTargetPath: event.remoteTargetPath,
                );
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
        _setLoading(true);
        final result = await _useCases.navigateToFolderUseCase.execute(path);
        _handleNavigateResult(result, path);
    }

    Future<void> _selectFile(String path) async {
        //TODO()
        throw UnimplementedError();
    }

    Future<void> _navigateRoot() async {
        _setLoading(true);
        final result = await _useCases.navigateToRootUseCase.execute();
        _handleNavigateResult(result, "/");
    }

    Future<void> _navigateUp() async {
        _setLoading(true);
        final result = await _useCases.navigateUpUseCase.execute(_state.currentPath);
        _handleNavigateResult(result, p.dirname(_state.currentPath));
    }

    Future<void> _handleNavigateResult(NavigationResult result, String requestedPath) async {
        _state = _state.copyWith(
            loading: false,
            currentPath: result.destinationPath,
            files: result.content,
            fileListError: result.error ?? "",
            isPinned: result.isPinned
        );
        notifyListeners();
    }

    Future<void> _toggleHidden() async {
        _state = _state.copyWith(showHidden: !_state.showHidden);
        notifyListeners();
    }

    Future<void> _pinUnpinFolder(String? path) async {
        await _useCases.pinUnpinDirectoryUseCase.execute(path ?? _state.currentPath);
        notifyListeners();
    }

    Future<void> _renamePinnedFolder({required String path, required String newAlias}) async {
        await _useCases.renamePinnedFolderUseCase.execute(path, newAlias);
    }

    Future<void> _updatePinnedFolderIcon({required String path, required int? newIcon}) async {
        await _useCases.changePinnedFolderIconUseCase.execute(path, newIcon);
    }

    Future<void> _deleteFile({required String path}) async {
        final result = await _useCases.deleteFileUseCase.execute(path);
        if (result) {
            _refreshContent();
        }
        else {
            _uiEvent.add(PermissionDenied());
        }
    }

    Future<void> _renameFile({required String filePath, required String newName}) async {
        final result = await _useCases.renameFileUseCase.execute(filePath, newName);
        if (result) {
            _refreshContent();
        }
        else {
            _uiEvent.add(PermissionDenied());
        }
    }

    Future<void> _createFolder({required String folderName}) async {
        final result = await _useCases.createDirectoryUseCase.execute(_state.currentPath, folderName);
        if (result) {
            _refreshContent();
        }
        else {
            _uiEvent.add(PermissionDenied());
        }
    }

    Future<void> _createFile({required String fileName}) async {
        final result = await _useCases.createFileUseCase.execute(_state.currentPath, fileName);
        if (result) {
            _refreshContent();
        }
        else {
            _uiEvent.add(PermissionDenied());
        }
    }

    void _selectViewMode(FileViewMode viewMode) {
        _state = _state.copyWith(viewMode: viewMode);
        notifyListeners();
    }

    Future<void> _downloadFile({required String remoteFilePath, required String localeTargetPath}) async {
        final result = await _useCases.downloadFileUseCase.execute(remoteFilePath, localeTargetPath);
        if (result) {
            _refreshContent();
        }
        else {
            _uiEvent.add(PermissionDenied());
        }
    }

    Future<void> _uploadFiles({
        required List<String> localeFilePaths,
        required String remoteTargetPath,
    }) async {
        if (localeFilePaths.isEmpty) {
            return;
        }

        var anySuccess = false;
        var anyDenied = false;

        for (final localeFilePath in localeFilePaths) {
            final result = await _useCases.uploadFileUseCase.execute(
                localeFilePath,
                remoteTargetPath,
            );
            if (result) {
                anySuccess = true;
            } else {
                anyDenied = true;
            }
        }

        if (anySuccess) {
            await _refreshContent();
        }
        if (anyDenied) {
            _uiEvent.add(PermissionDenied());
        }
    }

    Future<void> _refreshContent() async {
        _setLoading(true);
        final result = await _useCases.navigateToFolderUseCase.execute(_state.currentPath);
        _handleNavigateResult(result, _state.currentPath);
        _setLoading(false);
    }

    void _setLoading(bool loading) {
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

sealed class FileExplorerUiEvent {}

class PermissionDenied extends FileExplorerUiEvent {}