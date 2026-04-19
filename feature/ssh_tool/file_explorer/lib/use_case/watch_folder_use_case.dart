import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:flutter/foundation.dart';

class WatchFolderUseCase {
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const WatchFolderUseCase({
        required this.getCurrentServerProfileUseCase,
        required this.pinnedFolderRepository
    });

    Future<Stream<PinnedFolder?>> execute(String path) async {
        final profile = await getCurrentServerProfileUseCase.execute();
        if (profile == null) {
            if (kDebugMode) {
                print("[$_tag] No profile found!");
            }
            return Stream.value(null);
        }
        else {
            final folder = await pinnedFolderRepository.getByProfileIdAndPath(profile.id, path);
            if (folder == null) {
                if (kDebugMode) {
                    print("[$_tag] No folder found!");
                }
                return Stream.value(null);
            }
            return pinnedFolderRepository.watchFolder(folder.id);
        }
    }

    static final String _tag = "WatchFolderUseCase";

}