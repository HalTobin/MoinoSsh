import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/ssh_key_manager_screen.dart';
import '../presentation/ssh_key_manager_view_model.dart';
import '../use_case/apply_remote_authorized_keys_use_case.dart';
import '../use_case/get_remote_authorized_keys_use_case.dart';
import '../use_case/ssh_key_manager_use_cases.dart';

class SshKeyManagerProvider extends StatelessWidget {
  const SshKeyManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => GetRemoteAuthorizedKeysUseCase(
          sshService: context.read(),
          sftpService: context.read(),
        )),
        Provider(create: (context) => ApplyRemoteAuthorizedKeysUseCase(
          sftpService: context.read(),
        )),
        Provider(create: (context) => SshKeyManagerUseCases(
          getRemoteAuthorizedKeysUseCase: context.read(),
          applyRemoteAuthorizedKeysUseCase: context.read(),
        )),
        ChangeNotifierProvider(create: (context) => SshKeyManagerViewModel(
          sshKeyManagerUseCases: context.read(),
        )),
      ],
      child: Consumer<SshKeyManagerViewModel>(
        builder: (context, viewModel, child) {
          return SshKeyManagerScreen(
            state: viewModel.state,
            onEvent: viewModel.onEvent,
          );
        },
      ),
    );
  }
}
