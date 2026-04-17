import 'package:domain/model/ssh/favorite_service.dart';
import 'package:domain/model/response_result.dart';
import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:flutter/foundation.dart';

class UpsertServiceToFavoriteUseCase {
    UpsertServiceToFavoriteUseCase({
        required ServerProfileRepository serverProfileRepository,
        required FavoriteServiceRepository favoriteServiceRepository,
        required SshService sshService
    })
        : _serverProfileRepository = serverProfileRepository,
          _favoriteServiceRepository = favoriteServiceRepository,
          _sshService = sshService;

    final SshService _sshService;
    final FavoriteServiceRepository _favoriteServiceRepository;
    final ServerProfileRepository _serverProfileRepository;

    Future<ResponseResult<bool>> execute({
        required String serviceName,
        required String? alias,
        required int? iconId
    }) async {

        if (kDebugMode) {
            print("Save service: $serviceName, with alias: $alias");
        }

        final SshProfile? profile = _sshService.getCurrentProfile();
        if (profile != null) {
            final int? profileId = await _serverProfileRepository.getProfileIdByFields(
                url: profile.url,
                port: profile.port,
                user: profile.user
            );
            if (profileId != null) {
                final FavoriteService? service = await _favoriteServiceRepository.getFavoriteServiceByTitleAndProfileId(
                    profileId: profileId,
                    serviceName: serviceName
                );
                final serviceId = service?.id;
                if (serviceId != null) {
                    final UpdateFavoriteService service = UpdateFavoriteService(
                        id: serviceId,
                        profileId: profileId,
                        name: serviceName,
                        alias: alias,
                        iconId: iconId
                    );
                    _favoriteServiceRepository.updateService(service);
                    return ResponseSucceed(true);
                }
                else {
                    final NewFavoriteService service = NewFavoriteService(
                        profileId: profileId,
                        name: serviceName,
                        alias: alias,
                        iconId: iconId
                    );
                    _favoriteServiceRepository.saveService(service);
                    return ResponseSucceed(true);
                }
            }
            else {
              return ResponseFailed(error: "couldn't find matching profileId");
            }
        }
        else {
            return ResponseFailed(error: "profile is null");
        }
    }
}