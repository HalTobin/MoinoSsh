import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/ssh_key_manager_screen.dart';
import '../presentation/ssh_key_manager_view_model.dart';
import '../use_case/apply_remote_authorized_keys_use_case.dart';
import '../use_case/get_remote_authorized_keys_use_case.dart';
import '../use_case/resolve_authorized_keys_path_use_case.dart';
import '../use_case/ssh_key_manager_use_cases.dart';

class SshKeyManagerProvider extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  const SshKeyManagerProvider({
    super.key,
    required this.title,
    required this.onBack,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ResolveAuthorizedKeysPathUseCase(
          sshService: context.read(),
        )),
        Provider(create: (context) => GetRemoteAuthorizedKeysUseCase(
          resolveAuthorizedKeysPathUseCase: context.read(),
          sftpService: context.read(),
        )),
        Provider(create: (context) => ApplyRemoteAuthorizedKeysUseCase(
          sftpService: context.read(),
          sshService: context.read(),
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
            title: title,
            onBack: onBack,
            actions: actions,
          );
        },
      ),
    );
  }
}
