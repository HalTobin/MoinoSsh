import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:flutter/foundation.dart';

class DeleteServerUseCase {
    final ServerProfileRepository serverProfileRepository;
    final FavoriteServiceRepository favoriteServiceRepository;
    final PinnedFolderRepository pinnedFolderRepository;

    DeleteServerUseCase({
        required this.serverProfileRepository,
        required this.favoriteServiceRepository,
        required this.pinnedFolderRepository
    });

    Future<void> execute(int profileId) async {
        if (kDebugMode) {
            print("[DeleteServerUseCase] Deleting server with id: $profileId");
        }

        final services = await favoriteServiceRepository.getFavoriteServicesByProfileId(profileId);
        for (var service in services) {
            favoriteServiceRepository.unmarkService(service.id);
        }

        await pinnedFolderRepository.deleteByProfileId(profileId);
        await serverProfileRepository.deleteProfile(profileId);
    }

}