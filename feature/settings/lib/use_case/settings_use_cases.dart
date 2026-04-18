import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/listen_user_preferences_use_case.dart';
import 'package:feature_settings/use_case/toggle_keep_password_during_session_use_case.dart';
import 'package:feature_settings/use_case/toggle_material_you_use_case.dart';
import 'package:feature_settings/use_case/toggle_show_hidden_file_use_case.dart';
import 'package:feature_settings/use_case/update_contrast_use_case.dart';
import 'package:feature_settings/use_case/update_theme_use_case.dart';

import 'delete_key_use_case.dart';

class SettingsUseCases {
    final ListenUserPreferencesUseCase listenUserPreferencesUseCase;
    final UpdateThemeUseCase updateThemeUseCase;
    final UpdateContrastUseCase updateContrastUseCase;
    final ToggleMaterialYouUseCase toggleMaterialYouUseCase;
    final ToggleKeepPasswordDuringSessionUseCase toggleKeepPasswordDuringSessionUseCase;
    final ToggleShowHiddenFileUseCase toggleShowHiddenFileUseCase;
    final DeleteKeyUseCase deleteKeyUseCase;
    final CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase;

    SettingsUseCases({
        required this.listenUserPreferencesUseCase,
        required this.updateThemeUseCase,
        required this.updateContrastUseCase,
        required this.toggleMaterialYouUseCase,
        required this.toggleKeepPasswordDuringSessionUseCase,
        required this.toggleShowHiddenFileUseCase,
        required this.deleteKeyUseCase,
        required this.checkBiometricsAvailabilityUseCase
    });

}