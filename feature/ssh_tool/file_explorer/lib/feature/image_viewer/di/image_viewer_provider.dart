import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_screen.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_view_model.dart';
import 'package:feature_file_explorer/feature/image_viewer/use_case/image_viewer_use_cases.dart';
import 'package:feature_file_explorer/feature/image_viewer/use_case/load_image_bytes_use_case.dart';
import 'package:feature_file_explorer/feature/image_viewer/use_case/parse_image_metadata_use_case.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageViewerProvider extends StatelessWidget {
  final String filePath;

  const ImageViewerProvider({
    super.key,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LoadImageBytesUseCase(sftpService: context.read())),
        Provider(create: (_) => const ParseImageMetadataUseCase()),
        Provider(
          create: (context) => ImageViewerUseCases(
            loadImageBytesUseCase: context.read(),
            parseImageMetadataUseCase: context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ImageViewerViewModel(
            imageViewerUseCases: context.read(),
            filePath: filePath,
          ),
        ),
      ],
      child: Consumer<ImageViewerViewModel>(
        builder: (builder, viewmodel, child) {
          return ImageViewerScreen(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
            uiEvent: viewmodel.uiEvent,
          );
        },
      ),
    );
  }
}
