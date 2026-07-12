import 'package:collection/collection.dart';
import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:flutter/foundation.dart';

class PinUnpinDirectoryUseCase {
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const PinUnpinDirectoryUseCase({
        required this.getCurrentServerProfileUseCase,
        required this.pinnedFolderRepository
    });

    Future<void> execute(String path) async {
        final profile = await getCurrentServerProfileUseCase.execute();
        if (profile == null) {
            if (kDebugMode) {
                print("[$_tag] No profile found!");
            }
            return;
        }

        final pinnedFolder = await pinnedFolderRepository.getByProfileIdAndPath(profile.id, path);
        if (pinnedFolder != null) {
            if (kDebugMode) {
                print("[$_tag] Unpinning folder: $path");
            }
            pinnedFolderRepository.unpinFolder(pinnedFolder.id);
        }
        else {
            final profileFolders = await pinnedFolderRepository.getFoldersByProfileId(profile.id);
            final lastCustomIndex = profileFolders.map((e) => e.customIndex).maxOrNull ?? 0;
            final customIndex = lastCustomIndex + 1;

            final folder = NewPinnedFolder(
                profileId: profile.id,
                path: path,
                alias: null,
                customIndex: customIndex
            );
            pinnedFolderRepository.pinFolder(folder);
        }
    }

    static final String _tag = "PinUnpinDirectoryUseCase";

}