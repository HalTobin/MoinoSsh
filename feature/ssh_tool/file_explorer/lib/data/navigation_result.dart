import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:path/path.dart' as p;

class NavigationResult {
    final String destinationPath;
    final List<FileEntry> content;
    final bool isPinned;

    const NavigationResult({
        required this.destinationPath,
        required this.content,
        required this.isPinned
    });

    bool get alreadyAtRoot => p.dirname(destinationPath) == destinationPath;
}