import 'dart:math' as math;
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

    String get formattedSize {
        if (size <= 0) return "0 B";
        const suffixes = ["B", "KB", "MB", "GB", "TB"];
        int i = (math.log(size) / math.log(1024)).floor();
        i = math.min(i, suffixes.length - 1);

        double calculatedSize = size / math.pow(1024, i);
        return "${calculatedSize.toStringAsFixed(1)} ${suffixes[i]}";
    }

    bool get isHidden => name.startsWith('.');
}