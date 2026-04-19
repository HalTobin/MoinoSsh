import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';
import 'package:feature_file_explorer/use_case/navigate_to_folder_use_case.dart';

import 'package:path/path.dart' as p;

class NavigateUpUseCase {
    final NavigateToFolderUseCase navigateToFolderUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const NavigateUpUseCase({
        required this.navigateToFolderUseCase,
        required this.pinnedFolderRepository
    });

    Future<NavigationResult?> execute(String path) async {
        final String parentPath = p.dirname(path);
        if (parentPath == path) {
            return await navigateToFolderUseCase.execute(path);
        }
        return await navigateToFolderUseCase.execute(parentPath);
    }

}