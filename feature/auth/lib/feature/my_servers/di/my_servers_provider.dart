import 'package:feature_auth/feature/my_servers/use_case/auth_from_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/my_servers_viewmodel.dart';
import '../use_case/check_quick_connect_availability_use_case.dart';
import '../use_case/load_profiles_use_case.dart';
import '../use_case/my_servers_use_cases.dart';
import '../use_case/watch_server_profiles_use_case.dart';

class MyServersProvider extends StatelessWidget {
  final Widget child;

  const MyServersProvider({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => (CheckQuickConnectAvailabilityUseCase())),
        Provider(
          create: (context) => (
            LoadProfilesUseCase(serverProfileRepository: context.read())
          )
        ),
        Provider(
          create: (context) => (
            WatchServerProfilesUseCase(
              serverProfileRepository: context.read()
            )
          ),
        ),
        Provider(
          create: (context) => (
            AuthFromProfileUseCase(
              sshService: context.read(),
              serverProfileRepository: context.read(),
              biometricsService: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            MyServersUseCases(
              authFromProfileUseCase: context.read(),
              loadProfilesUseCase: context.read(),
              loadSshFileUseCase: context.read(),
              sshConnectUseCase: context.read(),
              checkPasswordRequirementByServerProfileIdUseCase: context.read(),
              checkQuickConnectAvailabilityUseCase: context.read(),
              watchServerProfilesUseCase: context.read()
            )
          )
        ),
        ChangeNotifierProvider(
          create: (context) => MyServersViewModel(
            myServersUseCases: context.read()
          )
        )
      ],
      child: child
    );
  }

}