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
      _observeSshConnectionStatus();
    }

    final MainUseCases _useCases;
    MainState _state = MainState();
    MainState get state => _state;

    StreamSubscription<bool>? _passwordAvailabilitySubscription;

    void onEvent(MainEvent event) {
        switch (event) {
            case SshLogOut():
                _useCases.sshLogOutUseCase.execute();
            case SetOnPasswordRequest():
                _useCases.setOnPasswordRequestUseCase.execute(event.onPasswordRequest);
        }
    }

    Future<String?> fetchSshPassword() {
        return _useCases.fetchSshPasswordUseCase.execute();
    }

    void _observeSshConnectionStatus() {
        _useCases.listenSshConnectUseCase.execute().addListener(() {
            bool isConnect = _useCases.listenSshConnectUseCase.execute().value;
            if (kDebugMode) { print("SSH Connection status: $isConnect"); }
            SshProfile currentProfile = _useCases.getCurrentSshProfileUseCase.execute();
            _state = _state.copyWith(isConnected: isConnect, profile: currentProfile);
            notifyListeners();
        });
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