import 'package:domain/model/preferences/app_theme.dart';
import 'package:domain/repository/preference_repository.dart';

class UpdateThemeUseCase {
    UpdateThemeUseCase({
        required PreferenceRepository preferenceRepository
    }): _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Future<void> execute(String themeIdentifier) async {
        final AppTheme theme = AppTheme.fromIdentifier(themeIdentifier);
        await _preferenceRepository.updateTheme(theme);
    }
}