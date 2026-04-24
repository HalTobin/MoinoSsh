import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';
import 'package:feature_file_explorer/use_case/navigate_to_folder_use_case.dart';

class NavigateToRootUseCase {
    final NavigateToFolderUseCase navigateToFolderUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const NavigateToRootUseCase({
        required this.navigateToFolderUseCase,
        required this.pinnedFolderRepository
    });

    Future<NavigationResult> execute() async {
        return await navigateToFolderUseCase.execute("/");
    }

}