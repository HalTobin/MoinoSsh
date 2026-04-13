import 'package:domain/model/preferences/app_theme.dart';

extension AppThemeText on AppTheme {
    String getText() {
        switch (this) {
            case AppTheme.light:
                return "Light";
            case AppTheme.dark:
                return "Dark";
            case AppTheme.auto:
                return "System";
        }
    }
}