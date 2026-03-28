import 'package:di/entry_point_provider.dart';
import 'package:flutter/material.dart';
import 'package:ls_server_app/presentation/main_screen.dart';
import 'package:ls_server_app/presentation/main_viewmodel.dart';
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
      child: MaterialApp(
        title: 'Moino Service Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
            seedColor: Color(0xFF181933)
          ),
        ),
        home: Scaffold(
          body: Consumer<MainViewModel>(
            builder: (context, viewmodel, child) {
              return MainScreen(
                state: viewmodel.state,
                onEvent: viewmodel.onEvent,
                onFetchPasswordBiometrics: viewmodel.state.sessionBiometricsAvailable ? viewmodel.fetchSshPassword : null,
              );
            }
          ),
        ),
      )
    );
  }
}
