import 'package:feature_file_explorer/feature/file_content/presentation/file_content_screen.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_view_model.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileContentProvider extends StatelessWidget{
  const FileContentProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => (
            FileContentUseCases()
          )
        ),
        ChangeNotifierProvider(create: (context) => (
          FileContentViewModel(fileContentUseCase: context.read())
        ))
      ],
      child: Consumer<FileContentViewModel>(
        builder: (builder, viewmodel, child) {
          return FileContentScreen(
            state: viewmodel.state
          );
        }
      )
    );
  }

}