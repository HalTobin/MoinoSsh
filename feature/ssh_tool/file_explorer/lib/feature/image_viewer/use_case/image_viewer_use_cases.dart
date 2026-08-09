import 'package:feature_file_explorer/feature/image_viewer/use_case/load_image_bytes_use_case.dart';
import 'package:feature_file_explorer/feature/image_viewer/use_case/parse_image_metadata_use_case.dart';

class ImageViewerUseCases {
    final LoadImageBytesUseCase loadImageBytesUseCase;
    final ParseImageMetadataUseCase parseImageMetadataUseCase;

    const ImageViewerUseCases({
        required this.loadImageBytesUseCase,
        required this.parseImageMetadataUseCase,
    });
}
