import 'package:domain/model/preferences/app_contrast.dart';
import 'package:domain/model/preferences/app_theme.dart';

class UserPreferences {
    final AppTheme theme;
    final AppContrast contrast;
    final bool materialYou;

    const UserPreferences({
        required this.theme,
        required this.contrast,
        required this.materialYou
    });

    static const UserPreferences defaultPreferences = UserPreferences(
        theme: AppTheme.auto,
        contrast: AppContrast.low,
        materialYou: true
    );
}