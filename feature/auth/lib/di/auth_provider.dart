import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../feature/my_servers/use_case/check_password_requirement_by_server_profile_id_use_case.dart';
import '../presentation/auth_screen.dart';
import '../use_case/auth_use_cases.dart';

class AuthProvider extends StatelessWidget {

  const AuthProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (
          CheckPasswordRequirementByServerProfileIdUseCase(
            serverProfileRepository: context.read(),
            loadSshFileUseCase: context.read()
          )
        )),
        Provider(
          create: (context) => (
            AuthUseCases(
              loadSshFileUseCase: context.read(),
              checkWrongFieldsUseCase: context.read(),
              sshConnectUseCase: context.read()
            )
          )
        ),
      ],
      child: AuthScreen()
    );
  }
}