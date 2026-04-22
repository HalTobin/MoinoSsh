sealed class FileExplorerEvent {}

class OpenFolder extends FileExplorerEvent {
    final String folderPath;

    OpenFolder({required this.folderPath});
}

class SelectFile extends FileExplorerEvent {
    final String filePath;

    SelectFile({required this.filePath});
}

class NavigateRootEvent extends FileExplorerEvent {}

class NavigateUpEvent extends FileExplorerEvent {}

class ToggleHiddenEvent extends FileExplorerEvent {}

class PinUnpinEvent extends FileExplorerEvent {
    final String? path;

    PinUnpinEvent({this.path});
}

class RenamePinnedFolder extends FileExplorerEvent {
    final String path;
    final String newAlias;

    RenamePinnedFolder({
        required this.path,
        required this.newAlias
    });
}