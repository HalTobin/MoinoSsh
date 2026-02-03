import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/repository/preference_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/ssh_service.dart';

import '../model/ConnectWithProfilePasswordMethod.dart';

class AuthFromProfileUseCase {
    AuthFromProfileUseCase({
        required SshService sshService,
        required PreferenceRepository preferenceRepository,
        required ServerProfileRepository serverProfileRepository
    })
        : _sshService = sshService,
          _preferenceRepository = preferenceRepository,
          _serverProfileRepository = serverProfileRepository;

    final SshService _sshService;
    final PreferenceRepository _preferenceRepository;
    final ServerProfileRepository _serverProfileRepository;

    Future<ConnectionStatus> execute(
        int serverProfileId,
        ConnectWithProfilePasswordMethod method
    ) {

    }

}