import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:pointycastle/export.dart';

class BiometricsServiceImpl implements BiometricsService {
    final ServerProfileRepository _serverProfileRepository;
    final BiometricStorage _biometricStorage;

    // The constant name for our master vault
    static const String _masterKeyVaultId = 'ssh_app_master_encryption_key';

    BiometricsServiceImpl({
        required ServerProfileRepository serverProfileRepository,
        BiometricStorage? biometricStorage,
    }) : _serverProfileRepository = serverProfileRepository,
         _biometricStorage = biometricStorage ?? BiometricStorage();

    @override
    Future<bool> isBiometricsSupported() async {
        final response = await _biometricStorage.canAuthenticate();
        return response == CanAuthenticateResponse.success;
    }

    Uint8List _generateSecureRandom(int length) {
        final random = Random.secure();
        return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
    }

    /// Retrieves the Master Key from hardware. If it doesn't exist, generates
    /// a secure 256-bit key and saves it behind biometrics.
    Future<String?> _getOrCreateMasterKey(String promptMessage) async {
        try {
            final vault = await _biometricStorage.getStorage(
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
                final newKey = _generateSecureRandom(32);
                masterKeyBase64 = base64.encode(newKey);
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
                final key = base64.decode(masterKeyBase64);
                final iv = _generateSecureRandom(16);

                final cipher = GCMBlockCipher(AESEngine())
                    ..init(true, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

                final input = utf8.encode(password);
                final output = cipher.process(Uint8List.fromList(input));

                return '${base64.encode(iv)}:${base64.encode(output)}';
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

                final iv = base64.decode(parts[0]);
                final encryptedData = base64.decode(parts[1]);
                final key = base64.decode(masterKeyBase64);

                final cipher = GCMBlockCipher(AESEngine())
                    ..init(false, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));

                final output = cipher.process(Uint8List.fromList(encryptedData));

                return utf8.decode(output);
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
            final vault = await _biometricStorage.getStorage(_masterKeyVaultId);
            await vault.delete();
        } catch (e) {
            if (kDebugMode) print('Failed to delete Master Key: $e');
        }

        // 2. Clear the database entries
        await _serverProfileRepository.deletePasswords();
    }

}