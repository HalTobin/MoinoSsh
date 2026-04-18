import 'package:feature_file_explorer/use_case/list_folder_content_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../presentation/file_explorer_screen.dart';
import '../presentation/file_explorer_view_model.dart';
import '../use_case/file_explorer_use_cases.dart';

class ServiceManagerProvider extends StatelessWidget {
  const ServiceManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (ListFolderContentUseCase(sshService: context.read()))),
        Provider(
          create: (context) => (
            FileExplorerUseCases(
              listFolderContentUseCase: context.read()
            )
          )
        )
      ],
      child: Consumer<FileExplorerViewModel>(
        builder: (builder, viewmodel, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return FileExplorerScreen(
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