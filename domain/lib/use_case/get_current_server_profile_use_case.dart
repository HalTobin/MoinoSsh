import 'package:domain/model/server_profile.dart';
import 'package:domain/service/ssh_client_service.dart';

import '../repository/server_profile_repository.dart';

class GetCurrentServerProfileUseCase {
    GetCurrentServerProfileUseCase({
        required SshClientService sshClientService,
        required ServerProfileRepository serverProfileRepository
    }): _sshClientService = sshClientService,
        _serverProfileRepository = serverProfileRepository;

    final SshClientService _sshClientService;
    final ServerProfileRepository _serverProfileRepository;

    Future<ServerProfile?> execute() async {
        final sshProfile = _sshClientService.getProfile();
        if (sshProfile == null) return null;

        final localProfileId = await _serverProfileRepository.getProfileIdByFields(
            url: sshProfile.url,
            port: sshProfile.port,
            user: sshProfile.user
        );
        if (localProfileId == null) return null;

        final localProfile = await _serverProfileRepository.getProfileById(localProfileId);
        return localProfile;
    }

}