import 'package:feature_file_explorer/feature/image_viewer/use_case/load_image_bytes_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../use_case/image_viewer_use_cases.dart';

class ImageViewerProvider extends StatelessWidget {
  const ImageViewerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LoadImageBytesUseCase(sftpService: context.read())),
        Provider(
          create: (context) => ImageViewerUseCases(
            loadImageBytesUseCase: context.read()
          )
        )
      ]
    );
  }

}