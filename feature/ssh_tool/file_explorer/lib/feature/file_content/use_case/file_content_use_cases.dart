import 'package:feature_file_explorer/feature/file_content/use_case/determine_edited_lines_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/get_file_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/search_in_file_content_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/write_file_content_use_case.dart';

class FileContentUseCases {
    final GetFileUseCase getFileUseCase;
    final SearchInFileContentUseCase searchInFileContentUseCase;
    final DetermineEditedLinesUseCase determineEditedLinesUseCase;
    final WriteFileContentUseCase writeFileContentUseCase;

    const FileContentUseCases({
        required this.getFileUseCase,
        required this.searchInFileContentUseCase,
        required this.determineEditedLinesUseCase,
        required this.writeFileContentUseCase
    });
}