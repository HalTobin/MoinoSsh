import 'package:domain/model/user_preferences.dart';

abstract interface class PreferenceRepository {

    Future<UserPreferences> getUserPreferences();

    Stream<UserPreferences> getUserPreferencesStream();

    Future<void> saveUserPreferences(UserPreferences preferences);

    Future<void> updateBiometrics(bool biometrics);

}