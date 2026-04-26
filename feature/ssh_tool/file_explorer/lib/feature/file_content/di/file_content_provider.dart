import 'package:feature_file_explorer/feature/file_content/presentation/file_content_screen.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_view_model.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/get_file_name_from_path_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/read_file_as_text_use_case.dart';
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
        Provider(create: (context) => (ReadFileAsTextUseCase(sftpService: context.read()))),
        Provider(create: (_) => (GetFileNameFromPathUseCase())),
        Provider(
          create: (context) => (
            FileContentUseCases(
              getFileNameFromPathUseCase: context.read(),
              readFileAsTextUseCase: context.read()
            )
          )
        ),
        ChangeNotifierProvider(create: (context) => (
          FileContentViewModel(
            fileContentUseCase: context.read(),
            filePath: filePath
          )
        ))
      ],
      child: Consumer<FileContentViewModel>(
        builder: (builder, viewmodel, child) {
          return FileContentScreen(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
          );
        }
      )
    );
  }

}