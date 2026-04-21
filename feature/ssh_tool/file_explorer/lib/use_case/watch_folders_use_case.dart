import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:flutter/foundation.dart';

class WatchFoldersUseCase {
    final GetCurrentServerProfileUseCase getCurrentServerProfileUseCase;
    final PinnedFolderRepository pinnedFolderRepository;

    const WatchFoldersUseCase({
        required this.getCurrentServerProfileUseCase,
        required this.pinnedFolderRepository
    });

    Future<Stream<List<PinnedFolder>>> execute() async {
        final profile = await getCurrentServerProfileUseCase.execute();
        if (profile == null) {
            if (kDebugMode) {
                print("[$_tag] No profile found!");
            }
            return Stream.value(List.empty());
        }
        else {
            return pinnedFolderRepository.watchFoldersByProfileId(profile.id);
        }
    }

    static final String _tag = "WatchFolderUseCase";

}