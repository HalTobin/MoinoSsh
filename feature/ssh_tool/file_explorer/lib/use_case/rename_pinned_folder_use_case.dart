import 'package:collection/collection.dart';
import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:flutter/foundation.dart';

class RenamePinnedFolderUseCase {
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const RenamePinnedFolderUseCase({
        required this.getCurrentServerProfileUseCase,
        required this.pinnedFolderRepository
    });

    Future<void> execute(String path, String alias) async {
        final profile = await getCurrentServerProfileUseCase.execute();
        if (profile == null) {
            if (kDebugMode) {
                print("[$_tag] No profile found!");
            }
            return;
        }

        final pinnedFolder = await pinnedFolderRepository.getByProfileIdAndPath(profile.id, path);

        final newAlias = alias.isEmpty ? null : alias;

        if (pinnedFolder != null) {
            final renamedFolder = UpdatePinnedFolder(
                id: pinnedFolder.id,
                profileId: pinnedFolder.profileId,
                path: path,
                alias: newAlias,
                customIndex: pinnedFolder.customIndex
            );
            pinnedFolderRepository.updateFolder(renamedFolder);
        }
        else {
            if (kDebugMode) {
                print("[$_tag] No folder found for: profileId: ${profile.id}, path: $path");
            }
        }
    }

    static final String _tag = "RenamePinnedFolderUseCase";

}