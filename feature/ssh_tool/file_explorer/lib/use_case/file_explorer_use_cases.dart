import 'package:feature_file_explorer/use_case/check_default_show_hidden_use_case.dart';
import 'package:feature_file_explorer/use_case/select_file_use_case.dart';
import 'list_folder_content_use_case.dart';

class FileExplorerUseCases {
    final CheckDefaultShowHiddenUseCase checkDefaultShowHiddenUseCase;
    final ListFolderContentUseCase listFolderContentUseCase;
    final SelectFileUseCase selectFileUseCase;

    FileExplorerUseCases({
        required this.checkDefaultShowHiddenUseCase,
        required this.listFolderContentUseCase,
        required this.selectFileUseCase
    });
}