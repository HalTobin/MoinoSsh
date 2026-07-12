import 'dart:async';

import 'package:domain/service/ssh_client_service.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';

class ListenIsCurrentSshProfilePasswordAvailableUseCase {
    ListenIsCurrentSshProfilePasswordAvailableUseCase({
        required SshClientService sshClientService,
        required GetCurrentServerProfileUseCase getCurrentServerProfileUseCase,
        required CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase,
    }): _sshClientService = sshClientService,
        _getCurrentServerProfileUseCase = getCurrentServerProfileUseCase,
        _checkBiometricsAvailabilityUseCase = checkBiometricsAvailabilityUseCase;
    
    final SshClientService _sshClientService;
    final GetCurrentServerProfileUseCase _getCurrentServerProfileUseCase;
    final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;

    Stream<bool> execute() {
        return _sshClientService.watchProfile().asyncExpand((sshProfile) async* {
            if (sshProfile == null) {
                yield false;
                return;
            }

            final biometricsAvailable = await _checkBiometricsAvailabilityUseCase.execute();
            if (!biometricsAvailable) {
                yield false;
                return;
            }

            final profile = await _getCurrentServerProfileUseCase.execute();
            if (profile == null) {
                yield false;
                return;
            }

            yield profile.securedSessionPassword != null;
        });
    }
  
}