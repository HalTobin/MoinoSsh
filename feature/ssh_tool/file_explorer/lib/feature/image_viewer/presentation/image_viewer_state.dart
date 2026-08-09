import 'package:domain/model/image_file.dart';
import 'package:feature_file_explorer/feature/image_viewer/model/image_metadata.dart';
import 'package:ui/state/omit.dart';

class ImageViewerState {
    final bool loading;
    final String filePath;
    final ImageFile? file;
    final ImageMetadata? metadata;
    final String? errorMessage;

    const ImageViewerState({
        this.loading = true,
        this.filePath = "",
        this.file,
        this.metadata,
        this.errorMessage,
    });

    ImageViewerState copyWith({
        Defaulted<bool> loading = const Omit(),
        Defaulted<String> filePath = const Omit(),
        Defaulted<ImageFile?> file = const Omit(),
        Defaulted<ImageMetadata?> metadata = const Omit(),
        Defaulted<String?> errorMessage = const Omit(),
    }) {
        return ImageViewerState(
            loading: loading is Omit ? this.loading : loading as bool,
            filePath: filePath is Omit ? this.filePath : filePath as String,
            file: file is Omit ? this.file : file as ImageFile?,
            metadata: metadata is Omit ? this.metadata : metadata as ImageMetadata?,
            errorMessage: errorMessage is Omit ? this.errorMessage : errorMessage as String?,
        );
    }
}
