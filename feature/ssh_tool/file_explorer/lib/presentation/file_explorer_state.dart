
import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:domain/model/ssh/pinned_folder.dart';

import '../data/file_entry.dart';

class FileExplorerState {
    final String currentPath;
    final bool isPinned;
    final List<FileEntry> files;
    final String fileListError;
    final List<PinnedFolder> pinnedFolders;
    final bool loading;
    final String error;
    final bool showHidden;
    final FileViewMode viewMode;

    FileExplorerState({
        this.currentPath = "/",
        this.isPinned = false,
        this.files = const [],
        this.fileListError = "",
        this.pinnedFolders = const [],
        this.loading = false,
        this.error = "",
        this.showHidden = false,
        this.viewMode = FileViewMode.list
    });

    FileExplorerState copyWith({
        String? currentPath,
        bool? isPinned,
        List<FileEntry>? files,
        String? fileListError,
        List<PinnedFolder>? pinnedFolders,
        bool? loading,
        String? error,
        bool? showHidden,
        FileViewMode? viewMode
    }) {
        return FileExplorerState(
            currentPath: currentPath ?? this.currentPath,
            isPinned: isPinned ?? this.isPinned,
            files: files ?? this.files,
            fileListError: fileListError ?? this.fileListError,
            pinnedFolders: pinnedFolders ?? this.pinnedFolders,
            loading: loading ?? this.loading,
            error: error ?? this.error,
            showHidden: showHidden ?? this.showHidden,
            viewMode: viewMode ?? this.viewMode
        );
    }
}