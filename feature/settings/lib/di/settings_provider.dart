import 'package:feature_settings/use_case/toggle_keep_password_during_session_use_case.dart';
import 'package:feature_settings/use_case/toggle_material_you_use_case.dart';
import 'package:feature_settings/use_case/toggle_show_hidden_file_use_case.dart';
import 'package:feature_settings/use_case/update_contrast_use_case.dart';
import 'package:feature_settings/use_case/update_file_view_mode_use_case.dart';
import 'package:feature_settings/use_case/update_theme_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../use_case/settings_use_cases.dart';
import '../use_case/delete_key_use_case.dart';
import '../presentation/settings_screen.dart';
import '../presentation/settings_view_model.dart';

class SettingsProvider extends StatelessWidget {
  final Function() onExit;

  const SettingsProvider({
    super.key,
    required this.onExit
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => (
            DeleteKeyUseCase(
              serverProfileRepository: context.read(),
              biometricsService: context.read()
            )
          )
        ),
        Provider(create: (context) => (UpdateThemeUseCase(preferenceRepository: context.read()))),
        Provider(create: (context) => (UpdateContrastUseCase(preferenceRepository: context.read()))),
        Provider(create: (context) => (ToggleMaterialYouUseCase(preferenceRepository: context.read()))),
        Provider(create: (context) => (ToggleKeepPasswordDuringSessionUseCase(preferenceRepository: context.read()))),
        Provider(create: (context) => (ToggleShowHiddenFileUseCase(preferenceRepository: context.read()))),
        Provider(create: (context) => (UpdateFileViewModeUseCase(preferenceRepository: context.read()))),
        Provider(
          create: (context) => (
            SettingsUseCases(
              listenUserPreferencesUseCase: context.read(),
              updateThemeUseCase: context.read(),
              updateContrastUseCase: context.read(),
              toggleMaterialYouUseCase: context.read(),
              toggleKeepPasswordDuringSessionUseCase: context.read(),
              toggleShowHiddenFileUseCase: context.read(),
              updateFileViewModeUseCase: context.read(),
              deleteKeyUseCase: context.read(),
              checkBiometricsAvailabilityUseCase: context.read()
            )
          )
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(
            settingsUseCases: context.read()
          ),
        )
      ],
      child: Consumer<SettingsViewModel>(
        builder: (contexts, viewmodel, child) => SettingsScreen(
          state: viewmodel.state,
          onEvent: viewmodel.onEvent,
          onExit: onExit,
        )
      )
    );
  }
}