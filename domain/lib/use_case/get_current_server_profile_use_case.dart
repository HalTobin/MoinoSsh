import 'package:domain/model/server_profile.dart';

import '../repository/server_profile_repository.dart';
import '../service/ssh_service.dart';

class GetCurrentServerProfileUseCase {
    GetCurrentServerProfileUseCase({
        required SshService sshService,
        required ServerProfileRepository serverProfileRepository
    }): _sshService = sshService,
        _serverProfileRepository = serverProfileRepository;

    final SshService _sshService;
    final ServerProfileRepository _serverProfileRepository;

    Future<ServerProfile?> execute() async {
        final sshProfile = _sshService.getCurrentProfile();
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