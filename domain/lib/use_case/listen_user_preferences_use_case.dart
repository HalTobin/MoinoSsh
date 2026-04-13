import 'dart:async';

import 'package:domain/model/preferences/user_preferences.dart';
import 'package:domain/repository/preference_repository.dart';

class ListenUserPreferencesUseCase {
    ListenUserPreferencesUseCase({required PreferenceRepository preferenceRepository})
        : _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Stream<UserPreferences> execute() {
        return _preferenceRepository.getUserPreferencesStream();
    }

}