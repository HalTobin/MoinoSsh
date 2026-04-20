import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:feature_file_explorer/data/file_type.dart';
import 'package:feature_file_explorer/data/navigation_result.dart';

class NavigateToFolderUseCase {
    final SftpService sftpService;
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const NavigateToFolderUseCase({
        required this.sftpService,
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

        final files = await sftpService.listDirectory(path);

        final entries = files.map((file) {
            final isHidden = file.name.startsWith('.');
            final fullPath = "$path/${file.name}".replaceAll('//', '/');

            if (file.isDirectory) {
                return Folder(
                    path: fullPath,
                    isHidden: isHidden,
                );
            } else {
                return File(
                    path: fullPath,
                    size: file.size,
                    isHidden: isHidden,
                    type: FileType.fromPath(file.name),
                );
            }
        }).toList();

        return NavigationResult(
            destinationPath: path,
            content: entries,
            isPinned: isPinned
        );
    }

}