import 'package:ui/state/omit.dart';

class SettingsState {
    final bool biometricsAvailable;

    SettingsState({
        this.biometricsAvailable = false
    });

    SettingsState copyWith({
        Defaulted<bool?> biometricsAvailable
    }) {
        return SettingsState(
            biometricsAvailable: biometricsAvailable is Omit ? this.biometricsAvailable : biometricsAvailable as bool
        );
    }

}