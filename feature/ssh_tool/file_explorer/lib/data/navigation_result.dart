import 'package:feature_file_explorer/data/file_entry.dart';

class NavigationResult {
    final String destinationPath;
    final List<FileEntry> content;

    const NavigationResult({
        required this.destinationPath,
        required this.content
    });

}