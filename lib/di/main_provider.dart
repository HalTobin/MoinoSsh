import 'package:flutter/material.dart';
import 'package:ls_server_app/presentation/main_viewmodel.dart';
import 'package:ls_server_app/use_case/fetch_ssh_password_use_case.dart';
import 'package:ls_server_app/use_case/get_current_ssh_profile_use_case.dart';
import 'package:ls_server_app/use_case/listen_is_current_ssh_profile_password_available_use_case.dart';
import 'package:ls_server_app/use_case/listen_ssh_connect_usecase.dart';
import 'package:ls_server_app/use_case/main_usecases.dart';
import 'package:ls_server_app/use_case/save_ssh_user_password_use_case.dart';
import 'package:ls_server_app/use_case/set_on_password_request_use_case.dart';
import 'package:ls_server_app/use_case/ssh_log_out_usecase.dart';
import 'package:provider/provider.dart';

class MainProvider extends StatelessWidget {
  final Widget child;

  const MainProvider({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (ListenSshConnectUseCase(sshService: context.read()))),
        Provider(create: (context) => (SshLogOutUseCase(sshService: context.read()))),
        Provider(create: (context) => (GetCurrentSshProfileUseCase(sshService: context.read()))),
        Provider(create: (context) => (SetOnPasswordRequestUseCase(sshService: context.read()))),
        Provider(
          create: (context) => (
            ListenIsCurrentSshProfilePasswordAvailableUseCase(
              getCurrentServerProfileUseCase: context.read(),
              sshService: context.read(),
              checkBiometricsAvailabilityUseCase: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            FetchSshPasswordUseCase(
              getCurrentServerProfileUseCase: context.read(),
              checkBiometricsAvailabilityUseCase: context.read(),
              biometricsService: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            SaveSshUserPasswordUseCase(
              checkBiometricsAvailabilityUseCase: context.read(),
              getCurrentServerProfileUseCase: context.read(),
              biometricsService: context.read(),
              serverProfileRepository: context.read()
            )
          )
        ),
        Provider(create: (context) => (
          MainUseCases(
            listenSshConnectUseCase: context.read(),
            sshLogOutUseCase: context.read(),
            getCurrentSshProfileUseCase: context.read(),
            setOnPasswordRequestUseCase: context.read(),
            listenIsCurrentSshProfilePasswordAvailableUseCase: context.read(),
            fetchSshPasswordUseCase: context.read(),
            checkBiometricsAvailabilityUseCase: context.read(),
            saveSshUserPasswordUseCase: context.read()
          )
        )),

        ChangeNotifierProvider(create: (context) => (MainViewModel(mainUseCases: context.read())))
      ],
      child: child
    );
  }
}