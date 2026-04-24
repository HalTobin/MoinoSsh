class RemoteFileItem {
    final String name;
    final bool isDirectory;
    final int size;
    final DateTime? lastModified;
    final String? permissions;

    const RemoteFileItem({
        required this.name,
        required this.isDirectory,
        required this.size,
        this.lastModified,
        this.permissions,
    });

    bool get isHidden => name.startsWith('.');
}

sealed class ListFileResult {}

class ListFileSuccess extends ListFileResult {
    final List<RemoteFileItem> files;

    ListFileSuccess({required this.files});
}

class ListFileFail extends ListFileResult {
    final String errorMessage;

    ListFileFail({required this.errorMessage});
}