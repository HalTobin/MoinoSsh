import 'package:collection/collection.dart';

enum AppTheme {
    auto(identifier: "auto"),
    light(identifier: "light"),
    dark(identifier: "dark");

    const AppTheme({
        required this.identifier
    });

    final String identifier;

    static AppTheme fromIdentifier(String themeIdentifier) {
        return AppTheme.values.firstWhereOrNull(
                (element) => element.identifier == themeIdentifier
        ) ?? AppTheme.auto;
    }
}