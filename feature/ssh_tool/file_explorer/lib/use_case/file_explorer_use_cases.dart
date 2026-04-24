import 'package:feature_file_explorer/use_case/change_pinned_folder_icon_use_case.dart';
import 'package:feature_file_explorer/use_case/get_default_show_hidden_use_case.dart';
import 'package:feature_file_explorer/use_case/get_default_view_mode_use_case.dart';
import 'package:feature_file_explorer/use_case/pin_unpin_directory_use_case.dart';
import 'package:feature_file_explorer/use_case/rename_pinned_folder_use_case.dart';
import 'package:feature_file_explorer/use_case/select_file_use_case.dart';
import 'package:feature_file_explorer/use_case/watch_folders_use_case.dart';
import 'navigate_to_folder_use_case.dart';
import 'navigate_to_root_use_case.dart';
import 'navigate_up_use_case.dart';

class FileExplorerUseCases {
    final CheckDefaultShowHiddenUseCase checkDefaultShowHiddenUseCase;
    final GetDefaultViewModeUseCase getDefaultViewModeUseCase;
    final WatchFoldersUseCase watchFoldersUseCase;
    final NavigateToFolderUseCase navigateToFolderUseCase;
    final NavigateToRootUseCase navigateToRootUseCase;
    final NavigateUpUseCase navigateUpUseCase;
    final SelectFileUseCase selectFileUseCase;
    final PinUnpinDirectoryUseCase pinUnpinDirectoryUseCase;
    final RenamePinnedFolderUseCase renamePinnedFolderUseCase;
    final ChangePinnedFolderIconUseCase changePinnedFolderIconUseCase;

    FileExplorerUseCases({
        required this.checkDefaultShowHiddenUseCase,
        required this.getDefaultViewModeUseCase,
        required this.navigateToFolderUseCase,
        required this.watchFoldersUseCase,
        required this.navigateToRootUseCase,
        required this.navigateUpUseCase,
        required this.selectFileUseCase,
        required this.pinUnpinDirectoryUseCase,
        required this.renamePinnedFolderUseCase,
        required this.changePinnedFolderIconUseCase
    });
}