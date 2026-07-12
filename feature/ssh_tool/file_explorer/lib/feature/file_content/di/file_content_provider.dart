import 'package:feature_file_explorer/feature/file_content/presentation/file_content_screen.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_view_model.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/determine_edited_lines_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/get_file_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/search_in_file_content_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/write_file_content_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileContentProvider extends StatelessWidget {
  final String filePath;

  const FileContentProvider({
    super.key,
    required this.filePath
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => GetFileUseCase(sftpService: context.read())),
        Provider(create: (_) => SearchInFileContentUseCase()),
        Provider(create: (_) => DetermineEditedLinesUseCase()),
        Provider(create: (_) => WriteFileContentUseCase(sftpService: context.read())),
        Provider(
          create: (context) => FileContentUseCases(
            getFileUseCase: context.read(),
            searchInFileContentUseCase: context.read(),
            determineEditedLinesUseCase: context.read(),
            writeFileContentUseCase: context.read()
          )
        ),
        ChangeNotifierProvider(create: (context) => FileContentViewModel(
          fileContentUseCase: context.read(),
          filePath: filePath
        ))
      ],
      child: Consumer<FileContentViewModel>(
        builder: (builder, viewmodel, child) {
          return FileContentScreen(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
            uiEvent: viewmodel.uiEvent,
          );
        }
      )
    );
  }

}