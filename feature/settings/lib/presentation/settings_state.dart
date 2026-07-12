import 'package:domain/model/preferences/user_preferences.dart';
import 'package:ui/state/omit.dart';

class SettingsState {
    final UserPreferences preferences;
    final bool biometricsAvailable;

    SettingsState({
        this.preferences = UserPreferences.defaultPreferences,
        this.biometricsAvailable = false
    });

    SettingsState copyWith({
        Defaulted<UserPreferences> preferences = const Omit(),
        Defaulted<bool?> biometricsAvailable = const Omit()
    }) {
        return SettingsState(
            preferences: preferences is Omit ? this.preferences : preferences as UserPreferences,
            biometricsAvailable: biometricsAvailable is Omit ? this.biometricsAvailable : biometricsAvailable as bool
        );
    }

}