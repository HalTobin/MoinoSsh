
import '../data/file_entry.dart';

class FileExplorerState {
    final String currentPath;
    final List<FileEntry> files;
    final bool loading;
    final String error;
    final bool showHidden;

    FileExplorerState({
        this.currentPath = "/",
        this.files = const [],
        this.loading = false,
        this.error = "",
        this.showHidden = false
    });

    FileExplorerState copyWith({
        String? currentPath,
        List<FileEntry>? files,
        bool? loading,
        String? error,
        bool? showHidden
    }) {
        return FileExplorerState(
            currentPath: currentPath ?? this.currentPath,
            files: files ?? this.files,
            loading: loading ?? this.loading,
            error: error ?? this.error,
            showHidden: showHidden ?? this.showHidden
        );
    }
}