import 'package:domain/model/ssh/favorite_service.dart';
import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/ssh_service.dart';

class GetServiceUseCase {
    GetServiceUseCase({
        required FavoriteServiceRepository favoriteServiceRepository,
        required ServerProfileRepository serverProfileRepository,
        required SshService sshService
    })
      : _favoriteServiceRepository = favoriteServiceRepository,
        _serverProfileRepository = serverProfileRepository,
        _sshService = sshService;

    final FavoriteServiceRepository _favoriteServiceRepository;
    final ServerProfileRepository _serverProfileRepository;
    final SshService _sshService;

    Future<FavoriteService?> execute({required String serviceName}) async {
        final SshProfile? sshProfile = _sshService.getCurrentProfile();
        if (sshProfile != null) {
            final int? profileId = await _serverProfileRepository.getProfileIdByFields(
                url: sshProfile.url,
                port: sshProfile.port,
                user: sshProfile.user
            );

            if (profileId != null) {
                return _favoriteServiceRepository.getFavoriteServiceByTitleAndProfileId(profileId: profileId, serviceName: serviceName);
            }
            else { return null; }
        }
        else { return null; }
    }
}