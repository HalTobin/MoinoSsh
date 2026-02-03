import 'dart:async';

import 'package:domain/model/user_preferences.dart';
import 'package:domain/repository/preference_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepositoryImpl implements PreferenceRepository {
    final prefs = SharedPreferencesAsync();

    final StreamController<UserPreferences> _controller = StreamController<UserPreferences>.broadcast();

    static final PreferenceRepositoryImpl _instance = PreferenceRepositoryImpl._internal();
    factory PreferenceRepositoryImpl() => _instance;

    PreferenceRepositoryImpl._internal();

    @override
    Future<UserPreferences> getUserPreferences() async {
        final defaultPrefs = UserPreferences.defaultPreferences;
        final bool biometrics = await _loadBool(_Keys.BIOMETRICS.key, defaultPrefs.biometrics);
        final bool dontAskBiometrics = await _loadBool(_Keys.DONT_ASK_BIOMETRICS.key, defaultPrefs.dontAskBiometrics);

        final preferences = UserPreferences(
            biometrics: biometrics,
            dontAskBiometrics: dontAskBiometrics
        );

        return preferences;
    }

    @override
    Stream<UserPreferences> getUserPreferencesStream() async* {
        yield await getUserPreferences();
        yield* _controller.stream;
    }

    @override
    Future<void> saveUserPreferences(UserPreferences preferences) async {
        _Keys.values.forEach((key) async {
            switch (key) {
                case _Keys.BIOMETRICS:
                    await _updateBool(key: key.key, value: preferences.biometrics, notify: false);
                case _Keys.DONT_ASK_BIOMETRICS:
                    await _updateBool(key: key.key, value: preferences.dontAskBiometrics, notify: false);
            }
        });
        _notify();
    }

    @override
    Future<void> updateBiometrics(bool biometrics) async {
        _updateBool(key: _Keys.BIOMETRICS.key, value: biometrics);
        final current = await getUserPreferences();
        _controller.add(current);
    }

    Future<bool> _loadBool(String key, bool defaultValue) async {
        return await prefs.getBool(key) ?? defaultValue;
    }

    Future<int> _loadInt(String key, int defaultValue) async {
        return await prefs.getInt(key) ?? defaultValue;
    }

    Future<String> _loadString(String key, String defaultValue) async {
        return await prefs.getString(key) ?? defaultValue;
    }

    Future<void> _updateBool({
        required String key,
        required bool value,
        bool notify = true
    }) async {
       await prefs.setBool(key, value);
       if (notify) { _notify(); }
    }

    Future<void> _updateInt({
        required String key,
        required int value,
        bool notify = true
    }) async {
        await prefs.setInt(key, value);
        if (notify) { _notify(); }
    }

    Future<void> _updateString({
        required String key,
        required String value,
        bool notify = true
    }) async {
        await prefs.setString(key, value);
        if (notify) { _notify(); }
    }

    Future<void> _notify() async {
        final current = await getUserPreferences();
        _controller.add(current);
    }

}

enum _Keys {
    BIOMETRICS("biometrics"),
    DONT_ASK_BIOMETRICS("dont_ask_biometrics");

    final String key;

    const _Keys(this.key);
}