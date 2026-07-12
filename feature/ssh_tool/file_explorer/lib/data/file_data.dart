import 'file_type.dart';

class FileData {
    final String name;
    final String path;
    final int size;
    final DateTime lastModified;
    final String? permissions;
    final String? owner;
    final String? group;

    FileData({
        required this.name,
        required this.path,
        required this.size,
        required this.lastModified,
        this.permissions,
        this.owner,
        this.group,
    });

    FileType? get type {
        return FileType.fromPath(name);
    }

    bool get isHidden => name.startsWith('.');
}