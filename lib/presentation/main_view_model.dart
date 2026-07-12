import 'dart:async';

import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:ls_server_app/presentation/main_event.dart';
import 'package:ls_server_app/presentation/main_state.dart';
import 'package:ls_server_app/use_case/main_usecases.dart';

class MainViewModel extends ChangeNotifier {
    MainViewModel({required MainUseCases mainUseCases})
      : _useCases = mainUseCases
    {
        _init();
    }

    final MainUseCases _useCases;
    MainState _state = MainState();
    MainState get state => _state;

    StreamSubscription<bool>? _passwordAvailabilitySubscription;

    Future<void> _init() async {
        _listenUserPreferences();
        _checkIfBiometricsAvailable();
        _observeSshConnectionStatus();
        _observeSshSessionBiometricsAvailability();
    }

    void onEvent(MainEvent event) {
        switch (event) {
            case SshLogOut():
                _useCases.sshLogOutUseCase.execute();
            case SetOnPasswordRequest():
                _useCases.setOnPasswordRequestUseCase.execute(event.onPasswordRequest);
            case SaveSshUserPassword():
                _useCases.saveSshUserPasswordUseCase.execute(event.password);
        }
    }

    void _listenUserPreferences() {
        _useCases.listenUserPreferencesUseCase.execute()
            .listen((preferences) {
                _state = _state.copyWith(userPreferences: preferences);
                notifyListeners();
            }
        );
    }

    Future<String?> fetchSshPassword() {
        return _useCases.fetchSshPasswordUseCase.execute();
    }

    Future<void> _checkIfBiometricsAvailable() async {
        final available = await _useCases.checkBiometricsAvailabilityUseCase.execute();
        _state = _state.copyWith(biometricsAvailable: available);
        notifyListeners();
    }

    void _observeSshConnectionStatus() {
        _useCases.listenSshConnectUseCase.execute()
            .listen((isConnected) {
                if (kDebugMode) { print("SSH Connection status: $isConnected"); }
                SshProfile currentProfile = _useCases.getCurrentSshProfileUseCase.execute();
                _state = _state.copyWith(isConnected: isConnected, profile: currentProfile);
                notifyListeners();
            }
        );
    }

    void _observeSshSessionBiometricsAvailability() {
        _passwordAvailabilitySubscription = _useCases.listenIsCurrentSshProfilePasswordAvailableUseCase.execute()
            .listen((isAvailable) {
            _state = _state.copyWith(sessionBiometricsAvailable: isAvailable);
            notifyListeners();
        },
            onError: (error) {
                if (kDebugMode) {
                    print("Error listening to SSH status: $error");
                }
            }
        );
    }

}