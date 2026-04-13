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
        Provider(
          create: (context) => (
            SettingsUseCases(
              listenUserPreferencesUseCase: context.read(),
              updateThemeUseCase: context.read(),
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