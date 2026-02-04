import 'dart:io';

import 'package:domain/repository/secured_preferences_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredPreferencesRepositoryImpl implements SecuredPreferencesRepository {

    final FlutterSecureStorage? storage = FlutterSecureStorage(
        aOptions: AndroidOptions.biometric(
            enforceBiometrics: true,
            biometricPromptTitle: 'Authentication Required',
        ),
        iOptions: IOSOptions(
            accessControlFlags: const [AccessControlFlag.biometryAny],
        ),
        mOptions: MacOsOptions(
            accessControlFlags: const [AccessControlFlag.biometryAny],
        )
    );

    @override
    Future<bool> isBiometricsSupported() async {
        if (storage == null) {
            return false;
        } else {
            if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
                return true;
            } else {
                return false;
            }
        }
    }

    @override
    Future<String?> getUserKey() async {
        return await storage?.read(
            key: _PASS_KEY,
            mOptions: MacOsOptions(
              accessControlFlags: const [AccessControlFlag.biometryAny],
            )
        );
    }

    @override
    Future<void> writeUserKey(String key) async {
        await storage?.write(key: key, value: _PASS_KEY);
    }

    static const _PASS_KEY = 'user_key';

}