import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';
import 'package:flutter/foundation.dart';

class SaveSshUserPasswordUseCase {
    SaveSshUserPasswordUseCase({
        required CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase,
        required GetCurrentServerProfileUseCase getCurrentServerProfileUseCase,
        required BiometricsService biometricsService,
        required ServerProfileRepository serverProfileRepository
    }): _checkBiometricsAvailabilityUseCase = checkBiometricsAvailabilityUseCase,
        _getCurrentServerProfileUseCase = getCurrentServerProfileUseCase,
        _biometricsService = biometricsService,
        _serverProfileRepository = serverProfileRepository;

    final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;
    final GetCurrentServerProfileUseCase _getCurrentServerProfileUseCase;
    final BiometricsService _biometricsService;
    final ServerProfileRepository _serverProfileRepository;

    Future<void> execute(String password) async {
        final biometricsAvailable = await _checkBiometricsAvailabilityUseCase.execute();
        if (!biometricsAvailable) return;
        final profile = await _getCurrentServerProfileUseCase.execute();
        if (profile == null) return;

        if (kDebugMode) {
            print("savingSshUserPassword()");
        }

        final secretPassword = await _biometricsService.encryptPassword(password);

        final updatedProfile = EditServerProfile(
            id: profile.id,
            name: profile.name,
            url: profile.url,
            port: profile.port,
            user: profile.user,
            keyPath: profile.keyPath,
            securedSshKeyPassword: profile.securedSshKeyPassword,
            securedSessionPassword: secretPassword
        );
        await _serverProfileRepository.updateProfile(updatedProfile);
        if (kDebugMode) {
            print("user password saved!");
        }
    }

}