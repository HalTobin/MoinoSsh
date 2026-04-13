import 'package:domain/model/preferences/app_theme.dart';

class UserPreferences {
    final AppTheme theme;

    const UserPreferences({
        required this.theme
    });

    static const UserPreferences defaultPreferences = UserPreferences(
        theme: AppTheme.auto
    );
}