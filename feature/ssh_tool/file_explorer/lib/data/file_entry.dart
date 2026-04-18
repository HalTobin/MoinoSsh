import 'package:feature_file_explorer/data/file_type.dart';

sealed class FileEntry {
    final String path;
    final bool isHidden;

    const FileEntry({
        required this.path,
        this.isHidden = false,
    });

    String get name => path.split('/').last;
}

class Folder extends FileEntry {
    const Folder({
        required super.path,
        super.isHidden,
    });
}

class File extends FileEntry {
    final FileType type;
    final int size;

    const File({
        required super.path,
        required this.type,
        required this.size,
        super.isHidden,
    });
}

