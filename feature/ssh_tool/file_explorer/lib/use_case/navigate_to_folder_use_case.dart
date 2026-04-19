import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';

class NavigateToFolderUseCase {
    final SshService sshService;
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const NavigateToFolderUseCase({
        required this.sshService,
        required this.getCurrentServerProfileUseCase,
        required this.pinnedFolderRepository
    });

    Future<NavigationResult?> execute(String path) async {
        final profile = await getCurrentServerProfileUseCase.execute();
        bool isPinned = false;
        if (profile != null) {
            final folder = await pinnedFolderRepository.getByProfileIdAndPath(profile.id, path);
            if (folder != null) {
                isPinned = true;
            }
        }


    }

}