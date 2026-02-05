import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:domain/service/ssh_service.dart';

import '../model/ConnectWithProfilePasswordMethod.dart';

class AuthFromProfileUseCase {
    AuthFromProfileUseCase({
        required SshService sshService,
        required ServerProfileRepository serverProfileRepository,
        required BiometricsService biometricsService
    })
        : _sshService = sshService,
          _serverProfileRepository = serverProfileRepository,
          _biometricsService = biometricsService;

    final SshService _sshService;
    final ServerProfileRepository _serverProfileRepository;
    final BiometricsService _biometricsService;

    Future<ConnectionStatus> execute(
        int serverProfileId,
        ConnectWithProfilePasswordMethod method
    ) async {
        final biometricsAvailable = await _biometricsService.isBiometricsSupported();
        if (biometricsAvailable) {
            final profile = await _serverProfileRepository.getProfileById(serverProfileId);
            if (profile == null) {
                return ConnectionFailed(error: "Profile not found");
            }
            switch (method) {
                case None():
                    return _sshService.connect(
                        user: profile.user,
                        serverUrl: profile.url,
                        serverPort: profile.port,
                        sshFilePath: profile.keyPath,
                        password: null
                    );
                case Password():
                    return _sshService.connect(
                        user: profile.user,
                        serverUrl: profile.url,
                        serverPort: profile.port,
                        sshFilePath: profile.keyPath,
                        password: method.password
                    );
                case Biometrics(): {
                    final cryptedPassword = profile.securedSshKeyPassword;
                    if (cryptedPassword != null) {
                        final password = await _biometricsService.decryptPassword(cryptedPassword);
                        return _sshService.connect(
                            user: profile.user,
                            serverUrl: profile.url,
                            serverPort: profile.port,
                            sshFilePath: profile.keyPath,
                            password: password
                        );
                    }
                    else {
                        return ConnectionFailed(error: "No password found in database");
                    }
                }
            }
        }
        return ConnectionFailed(error: "WIP");
    }

}