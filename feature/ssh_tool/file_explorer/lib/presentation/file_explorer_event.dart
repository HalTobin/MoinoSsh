sealed class FileExplorerEvent {}

class OpenFolder extends FileExplorerEvent {
    final String folderPath;

    OpenFolder({required this.folderPath});
}

class SelectFile extends FileExplorerEvent {
    final String filePath;

    SelectFile({required this.filePath});
}

class OpenFile extends FileExplorerEvent {
    final String filePath;

    OpenFile({required this.filePath});
}