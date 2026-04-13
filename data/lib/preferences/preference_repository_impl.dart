import 'dart:async';

import 'package:collection/collection.dart';
import 'package:domain/model/preferences/app_theme.dart';
import 'package:domain/model/preferences/user_preferences.dart';
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
        final String themeIdentifier = await _loadString(_Keys.APP_THEME.key, defaultPrefs.theme.identifier);
        final AppTheme theme = AppTheme.fromIdentifier(themeIdentifier);

        final preferences = UserPreferences(
            theme: theme
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
                case _Keys.APP_THEME:
                    await _updateString(key: key.key, value: preferences.theme.identifier, notify: false);
            }
        });
        _notify();
    }

    @override
    Future<void> updateTheme(AppTheme appTheme) async {
        _updateString(key: _Keys.APP_THEME.key, value: appTheme.identifier);
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
    APP_THEME("app_theme");

    final String key;

    const _Keys(this.key);
}