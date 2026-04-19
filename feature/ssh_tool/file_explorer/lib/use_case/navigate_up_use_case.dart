import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';

class NavigateUpUseCase {
    final SshService sshService;
    final PinnedFolderRepository pinnedFolderRepository;

    const NavigateUpUseCase({
        required this.sshService,
        required this.pinnedFolderRepository
    });

    Future<NavigationResult> execute(String path) async {
        //TODO()
        throw UnimplementedError();
    }

}