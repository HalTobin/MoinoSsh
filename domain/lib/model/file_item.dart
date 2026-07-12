class FileItem {
    final String name;
    final String fullName;
    final String extension;
    final String path;
    final bool isDirectory;

    const FileItem({
        required this.name,
        required this.fullName,
        required this.extension,
        required this.path,
        required this.isDirectory
    });
}