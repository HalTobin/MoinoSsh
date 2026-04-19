import 'package:feature_file_explorer/use_case/check_default_show_hidden_use_case.dart';
import 'package:feature_file_explorer/use_case/list_folder_content_use_case.dart';
import 'package:feature_file_explorer/use_case/navigate_to_root_use_case.dart';
import 'package:feature_file_explorer/use_case/navigate_up_use_case.dart';
import 'package:feature_file_explorer/use_case/pin_unpin_directory_use_case.dart';
import 'package:feature_file_explorer/use_case/rename_pinned_folder_use_case.dart';
import 'package:feature_file_explorer/use_case/select_file_use_case.dart';
import 'package:feature_file_explorer/use_case/watch_folder_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../presentation/file_explorer_screen.dart';
import '../presentation/file_explorer_view_model.dart';
import '../use_case/file_explorer_use_cases.dart';

class FileExplorerProvider extends StatelessWidget {
  const FileExplorerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (CheckDefaultShowHiddenUseCase(preferenceRepository: context.read()))),
        Provider(
          create: (context) => (
            WatchFolderUseCase(
              getCurrentServerProfileUseCase: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            ListFolderContentUseCase(
              sshService: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            NavigateToRootUseCase(
              sshService: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            NavigateUpUseCase(
              sshService: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(create: (context) => (SelectFileUseCase(sshService: context.read()))),
        Provider(
          create: (context) => (
            PinUnpinDirectoryUseCase(
              getCurrentServerProfileUseCase: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            RenamePinnedFolderUseCase(
              getCurrentServerProfileUseCase: context.read(),
              pinnedFolderRepository: context.read()
            )
          )
        ),
        Provider(
          create: (context) => (
            FileExplorerUseCases(
              checkDefaultShowHiddenUseCase: context.read(),
              watchFolderUseCase: context.read(),
              listFolderContentUseCase: context.read(),
              navigateToRootUseCase: context.read(),
              navigateUpUseCase: context.read(),
              selectFileUseCase: context.read(),
              pinUnpinDirectoryUseCase: context.read(),
              renamePinnedFolderUseCase: context.read()
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