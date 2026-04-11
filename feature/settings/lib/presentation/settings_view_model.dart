import 'package:flutter/material.dart';

import '../use_case/settings_use_cases.dart';
import 'settings_event.dart';
import 'settings_state.dart';


class SettingsViewModel extends ChangeNotifier {

    SettingsViewModel({
        required SettingsUseCases settingsUseCases
    })
        : _useCases = settingsUseCases {
            _init();
    }

    final SettingsUseCases _useCases;

    SettingsState _state = SettingsState();
    SettingsState get state => _state;

    Future<void> _init() async {
        _checkBiometricsAvailability();
    }

    Future<void> onEvent(SettingsEvent event) async {
        switch (event) {
            case DeleteKeys():
                _deleteKeys();
        }
    }

    Future<void> _deleteKeys() async {
        await _useCases.deleteKeyUseCase.execute();
    }

    Future<void> _checkBiometricsAvailability() async {
        final bool available = await _useCases.checkBiometricsAvailabilityUseCase.execute();
        _state = _state.copyWith(biometricsAvailable: available);
        notifyListeners();
    }

}