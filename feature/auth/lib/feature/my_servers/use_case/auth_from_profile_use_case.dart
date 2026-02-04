import 'package:domain/model/ssh/connection_status.dart';
import 'package:domain/repository/preference_repository.dart';
import 'package:domain/repository/secured_preferences_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:flutter/foundation.dart';

import '../model/ConnectWithProfilePasswordMethod.dart';

class AuthFromProfileUseCase {
    AuthFromProfileUseCase({
        required SshService sshService,
        required PreferenceRepository preferenceRepository,
        required ServerProfileRepository serverProfileRepository,
        required SecuredPreferencesRepository securedPreferencesRepository
    })
        : _sshService = sshService,
          _preferenceRepository = preferenceRepository,
          _serverProfileRepository = serverProfileRepository,
          _securedPreferencesRepository = securedPreferencesRepository;

    final SshService _sshService;
    final PreferenceRepository _preferenceRepository;
    final ServerProfileRepository _serverProfileRepository;
    final SecuredPreferencesRepository _securedPreferencesRepository;

    Future<ConnectionStatus> execute(
        int serverProfileId,
        ConnectWithProfilePasswordMethod method
    ) async {
        final biometricsAvailable = await _securedPreferencesRepository.isBiometricsSupported(); 
        if (biometricsAvailable) {
            final prefs = await _preferenceRepository.getUserPreferences();
            if (!prefs.dontAskBiometrics) {
                if (kDebugMode) {
                    print("[AuthFromProfileUseCase] Biometrics should be available");
                }
                final userKey = await _securedPreferencesRepository.getUserKey();
            }
        }
        return ConnectionFailed(error: "WIP");
    }

}