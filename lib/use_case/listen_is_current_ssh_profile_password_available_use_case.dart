import 'dart:async';

import 'package:domain/service/ssh_service.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';

class ListenIsCurrentSshProfilePasswordAvailableUseCase {
    ListenIsCurrentSshProfilePasswordAvailableUseCase({
        required SshService sshService,
        required GetCurrentServerProfileUseCase getCurrentServerProfileUseCase,
        required CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase,
    }): _sshService = sshService,
        _getCurrentServerProfileUseCase = getCurrentServerProfileUseCase,
        _checkBiometricsAvailabilityUseCase = checkBiometricsAvailabilityUseCase;
    
    final SshService _sshService;
    final GetCurrentServerProfileUseCase _getCurrentServerProfileUseCase;
    final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;

    Stream<bool> execute() {
        late final StreamController<bool> controller;

        Future<bool> isPasswordAvailable() async {
            final biometricsAvailable = await _checkBiometricsAvailabilityUseCase.execute();
            if (!biometricsAvailable) return false;

            final profile = await _getCurrentServerProfileUseCase.execute();
            if (profile == null) return false;

            return profile.securedSessionPassword != null;
        }

        Future<void> listener() async {
            final isAvailable = await isPasswordAvailable();
            controller.add(isAvailable);
        }

        // Initialize the controller with lifecycle callbacks
        controller = StreamController<bool>(
            onListen: () {
                _sshService.addListener(listener);
            },
            onCancel: () {
                _sshService.removeListener(listener);
                controller.close();
            },
        );

        return controller.stream;
    }
  
}