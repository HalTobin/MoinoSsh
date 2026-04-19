import 'package:feature_file_explorer/use_case/check_default_show_hidden_use_case.dart';
import 'package:feature_file_explorer/use_case/pin_unpin_directory_use_case.dart';
import 'package:feature_file_explorer/use_case/rename_pinned_folder_use_case.dart';
import 'package:feature_file_explorer/use_case/select_file_use_case.dart';
import 'package:feature_file_explorer/use_case/watch_folder_use_case.dart';
import 'navigate_to_folder_use_case.dart';
import 'navigate_to_root_use_case.dart';
import 'navigate_up_use_case.dart';

class FileExplorerUseCases {
    final CheckDefaultShowHiddenUseCase checkDefaultShowHiddenUseCase;
    final WatchFolderUseCase watchFolderUseCase;
    final NavigateToFolderUseCase navigateToFolderUseCase;
    final NavigateToRootUseCase navigateToRootUseCase;
    final NavigateUpUseCase navigateUpUseCase;
    final SelectFileUseCase selectFileUseCase;
    final PinUnpinDirectoryUseCase pinUnpinDirectoryUseCase;
    final RenamePinnedFolderUseCase renamePinnedFolderUseCase;

    FileExplorerUseCases({
        required this.checkDefaultShowHiddenUseCase,
        required this.navigateToFolderUseCase,
        required this.watchFolderUseCase,
        required this.navigateToRootUseCase,
        required this.navigateUpUseCase,
        required this.selectFileUseCase,
        required this.pinUnpinDirectoryUseCase,
        required this.renamePinnedFolderUseCase
    });
}