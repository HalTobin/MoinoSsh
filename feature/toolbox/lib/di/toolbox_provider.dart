import 'package:feature_toolbox/use_case/toolbox_use_cases.dart';
import 'package:feature_toolbox/use_case/watch_pending_download_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/toolbox_screen.dart';
import '../presentation/toolbox_view_model.dart';

class ToolboxProvider extends StatelessWidget {

  const ToolboxProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (WatchPendingDownloadUseCase(sftpService: context.read()))),
        Provider(create: (context) =>
          (
            ToolboxUseCases(
              watchPendingDownloadUseCase: context.read()
            )
          )
        ),
        ChangeNotifierProvider(create: (context) => (
          ToolboxViewModel(toolboxUseCases: context.read())
        ))
      ],
      child: Consumer<ToolboxViewModel>(
        builder: (builder, viewmodel, child) {
          return ToolboxScreen(
            state: viewmodel.state,
          );
        }
      ),
    );
  }

}