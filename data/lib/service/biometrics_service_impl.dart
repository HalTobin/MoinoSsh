import 'dart:isolate';

import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:encrypt/encrypt.dart' as enc;

class BiometricsServiceImpl implements BiometricsService {
    final ServerProfileRepository _serverProfileRepository;

    // The constant name for our master vault
    static const String _masterKeyVaultId = 'ssh_app_master_encryption_key';

    BiometricsServiceImpl({
        required ServerProfileRepository serverProfileRepository,
    }) : _serverProfileRepository = serverProfileRepository;

    @override
    Future<bool> isBiometricsSupported() async {
        final response = await BiometricStorage().canAuthenticate();
        return response == CanAuthenticateResponse.success;
    }

    /// Retrieves the Master Key from hardware. If it doesn't exist, generates
    /// a secure 256-bit key and saves it behind biometrics.
    Future<String?> _getOrCreateMasterKey(String promptMessage) async {
        try {
            final vault = await BiometricStorage().getStorage(
                _masterKeyVaultId,
                options: StorageFileInitOptions(authenticationRequired: true),
                promptInfo: PromptInfo(
                    iosPromptInfo: IosPromptInfo(accessTitle: promptMessage, saveTitle: promptMessage),
                    androidPromptInfo: AndroidPromptInfo(title: promptMessage),
                ),
            );

            String? masterKeyBase64 = await vault.read();

            // If no key exists, we generate a cryptographically secure 256-bit (32 byte) key
            if (masterKeyBase64 == null || masterKeyBase64.isEmpty) {
                if (kDebugMode) print("[BiometricsServiceImpl] Generating new Master Key...");
                final newKey = enc.Key.fromSecureRandom(32);
                masterKeyBase64 = newKey.base64;
                await vault.write(masterKeyBase64);
            }

            return masterKeyBase64;
        } catch (e) {
            if (kDebugMode) print('[BiometricsServiceImpl] Master Key error: $e');
            return null;
        }
    }

    @override
    Future<String?> encryptPassword(String password) async {
        if (kDebugMode) print("[BiometricsServiceImpl] Encrypting password...");

        final masterKeyBase64 = await _getOrCreateMasterKey('Authenticate to enable Secure SSH');
        if (masterKeyBase64 == null) return null;

        return await Isolate.run(() {
            try {
                final key = enc.Key.fromBase64(masterKeyBase64);
                final iv = enc.IV.fromSecureRandom(16);

                final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
                final encrypted = encrypter.encrypt(password, iv: iv);

                return '${iv.base64}:${encrypted.base64}';
            } catch (e) {
                if (kDebugMode) print("[BiometricsServiceImpl] Encryption failed: $e");
                return null;
            }
        });
    }

    @override
    Future<String?> decryptPassword(String ciphertext) async {
        if (kDebugMode) print("[BiometricsServiceImpl] Decrypting password...");

        final masterKeyBase64 = await _getOrCreateMasterKey('Unlock your SSH Session');
        if (masterKeyBase64 == null) return null;

        return await Isolate.run(() {
            try {
                final parts = ciphertext.split(':');
                if (parts.length != 2) throw Exception('Invalid ciphertext format');

                final iv = enc.IV.fromBase64(parts[0]);
                final encryptedText = enc.Encrypted.fromBase64(parts[1]);
                final key = enc.Key.fromBase64(masterKeyBase64);

                final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));

                return encrypter.decrypt(encryptedText, iv: iv);
            } catch (e) {
                if (kDebugMode) print("[BiometricsServiceImpl] Decryption failed: $e");
                return null;
            }
        });
    }

    @override
    Future<void> clearKeys() async {
        if (kDebugMode) print("[BiometricsServiceImpl] Wiping Master Key and Database...");

        try {
            // 1. Delete the Master Key vault. This instantly renders all database ciphertexts useless.
            final vault = await BiometricStorage().getStorage(_masterKeyVaultId);
            await vault.delete();
        } catch (e) {
            if (kDebugMode) print('Failed to delete Master Key: $e');
        }

        // 2. Clear the database entries
        await _serverProfileRepository.deletePasswords();
    }

}