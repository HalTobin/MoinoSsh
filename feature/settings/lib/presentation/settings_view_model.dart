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
        _listenPreferences();
        _checkBiometricsAvailability();
    }

    Future<void> _checkBiometricsAvailability() async {
        final bool available = await _useCases.checkBiometricsAvailabilityUseCase.execute();
        _state = _state.copyWith(biometricsAvailable: available);
        notifyListeners();
    }

    void _listenPreferences() {
        _useCases.listenUserPreferencesUseCase.execute()
            .listen((preferences) {
                _state = _state.copyWith(preferences: preferences);
                notifyListeners();
            }
        );
    }

    Future<void> onEvent(SettingsEvent event) async {
        switch (event) {
            case DeleteKeys():
                _deleteKeys();
            case UpdateTheme():
                _updateTheme(event.theme);
            case UpdateContrast():
                _updateContrast(event.contrast);
            case ToggleMaterialYou():
                _toggleMaterialYou();
        }
    }

    Future<void> _updateTheme(String theme) async {
        await _useCases.updateThemeUseCase.execute(theme);
    }

    Future<void> _updateContrast(String contrast) async {
        await _useCases.updateContrastUseCase.execute(contrast);
    }

    Future<void> _toggleMaterialYou() async {
        await _useCases.toggleMaterialYouUseCase.execute();
    }

    Future<void> _deleteKeys() async {
        await _useCases.deleteKeyUseCase.execute();
    }

}