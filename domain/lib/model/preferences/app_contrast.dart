import 'package:collection/collection.dart';

enum AppContrast {
    low(
        identifier: "low",
        level: 0.0
    ),
    medium(
        identifier: "medium",
        level: 0.5
    ),
    high(
        identifier: "high",
        level: 1.0
    );

    const AppContrast({
        required this.identifier,
        required this.level
    });

    final String identifier;
    final double level;

    static AppContrast fromIdentifier(String themeIdentifier) {
        return AppContrast.values.firstWhereOrNull(
                (element) => element.identifier == themeIdentifier
        ) ?? AppContrast.low;
    }
}