import 'package:collection/collection.dart';

enum FileViewMode {
    grid(identifier: "grid"),
    list(identifier: "list");

    const FileViewMode({
        required this.identifier
    });

    final String identifier;

    static FileViewMode fromIdentifier(String viewModeIdentifier) {
        return FileViewMode.values.firstWhereOrNull(
                (element) => element.identifier == viewModeIdentifier
        ) ?? FileViewMode.grid;
    }
}