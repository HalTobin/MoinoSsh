
import '../data/file_entry.dart';

class FileExplorerState {
    final String currentPath;
    final bool isPinned;
    final List<FileEntry> files;
    final bool loading;
    final String error;
    final bool showHidden;

    FileExplorerState({
        this.currentPath = "/",
        this.isPinned = false,
        this.files = const [],
        this.loading = false,
        this.error = "",
        this.showHidden = false
    });

    FileExplorerState copyWith({
        String? currentPath,
        bool? isPinned,
        List<FileEntry>? files,
        bool? loading,
        String? error,
        bool? showHidden
    }) {
        return FileExplorerState(
            currentPath: currentPath ?? this.currentPath,
            isPinned: isPinned ?? this.isPinned,
            files: files ?? this.files,
            loading: loading ?? this.loading,
            error: error ?? this.error,
            showHidden: showHidden ?? this.showHidden
        );
    }
}