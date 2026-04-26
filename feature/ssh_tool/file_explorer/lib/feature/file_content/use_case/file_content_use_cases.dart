import 'package:feature_file_explorer/feature/file_content/use_case/get_file_name_from_path_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/read_file_as_text_use_case.dart';

class FileContentUseCases {
    final GetFileNameFromPathUseCase getFileNameFromPathUseCase;
    final ReadFileAsTextUseCase readFileAsTextUseCase;

    const FileContentUseCases({
        required this.getFileNameFromPathUseCase,
        required this.readFileAsTextUseCase
    });
}