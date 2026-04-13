import '../model/preferences/user_preferences.dart';
import '../model/preferences/app_theme.dart';

abstract interface class PreferenceRepository {

    Future<UserPreferences> getUserPreferences();

    Stream<UserPreferences> getUserPreferencesStream();

    Future<void> saveUserPreferences(UserPreferences preferences);

    Future<void> updateTheme(AppTheme theme);

}