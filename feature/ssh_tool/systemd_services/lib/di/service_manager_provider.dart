import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../presentation/service_manager_screen.dart';
import '../presentation/service_manager_viewmodel.dart';
import '../use_case/run_systemctl_command_use_case.dart';
import '../use_case/service_manager_use_cases.dart';
import '../use_case/service_watcher_use_case.dart';

class ServiceManagerProvider extends StatelessWidget {
  const ServiceManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (RunSystemctlCommandUseCase(sshService: context.read()))),
        Provider(create: (context) => (
          ServiceWatcherUseCase(
            sshClientService: context.read(),
            sshService: context.read(),
            serverProfileRepository: context.read(),
            favoriteServiceRepository: context.read()
          )
        )),
        Provider(create: (context) => (
          ServiceManagerUseCases(
            runSystemctlCommandUseCase: context.read(),
            serviceWatcherUseCase: context.read()
          )
        )),
        ChangeNotifierProvider(create: (context) => (
          ServiceManagerViewmodel(serviceManagerUseCases: context.read())
        ))
      ],
      child: Consumer<ServiceManagerViewmodel>(
        builder: (builder, viewmodel, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return ServiceManagerScreen(
                state: viewmodel.state,
                onEvent: viewmodel.onEvent,
                isNarrow: ScreenFormatHelper.isNarrow(constraints),
              );
            }
          );
        }
      ),
    );
  }
}