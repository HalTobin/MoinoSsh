import 'dart:async';

import 'package:domain/service/biometrics_service.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';
import 'package:domain/use_case/get_current_server_profile_use_case.dart';

class FetchSshPasswordUseCase {
    FetchSshPasswordUseCase({
        required GetCurrentServerProfileUseCase getCurrentServerProfileUseCase,
        required CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase,
        required BiometricsService biometricsService
    }): _getCurrentServerProfileUseCase = getCurrentServerProfileUseCase,
        _checkBiometricsAvailabilityUseCase = checkBiometricsAvailabilityUseCase,
        _biometricsService = biometricsService;
    
    final GetCurrentServerProfileUseCase _getCurrentServerProfileUseCase;
    final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;
    final BiometricsService _biometricsService;

    Future<String?> execute() async {
        final biometricsAvailable = await _checkBiometricsAvailabilityUseCase.execute();
        if (!biometricsAvailable) { return null; }

        final profile = await _getCurrentServerProfileUseCase.execute();
        if (profile == null) { return null; }

        final securedPassword = profile.securedSessionPassword;
        if (securedPassword == null) { return null; }

        final password = await _biometricsService.decryptPassword(securedPassword);
        return password;
    }
  
}