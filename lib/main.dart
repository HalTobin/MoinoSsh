import 'package:di/entry_point_provider.dart';
import 'package:flutter/material.dart';
import 'package:ls_server_app/presentation/main_screen.dart';
import 'package:ls_server_app/presentation/main_viewmodel.dart';
import 'package:ls_server_app/presentation/util/get_brightness_from_theme.dart';
import 'package:provider/provider.dart';

import 'di/main_provider.dart';

void main() {
  runApp(
    EntryPointProvider(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainProvider(
      child: Consumer<MainViewModel>(
        builder: (context, viewmodel, child) {
          final preferences = viewmodel.state.userPreferences;
          return MaterialApp(
            title: 'Moino SSH',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  brightness: preferences.theme.resolvedBrightness(context),
                  seedColor: Color(0xFF181933)
              ),
            ),
            home: Scaffold(
              body: MainScreen(
                state: viewmodel.state,
                onEvent: viewmodel.onEvent,
                onFetchPasswordBiometrics: viewmodel.state.sessionBiometricsAvailable ? viewmodel.fetchSshPassword : null,
              )
            ),
          );
        }
      )
    );
  }
}
