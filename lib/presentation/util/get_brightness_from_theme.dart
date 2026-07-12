import 'package:domain/model/preferences/app_theme.dart';
import 'package:flutter/cupertino.dart';

extension AppThemeX on AppTheme {
    Brightness resolvedBrightness(BuildContext context) {
        switch (this) {
            case AppTheme.auto:
                return MediaQuery.platformBrightnessOf(context);
            case AppTheme.dark:
                return Brightness.dark;
            case AppTheme.light:
                return Brightness.light;
        }
    }
}