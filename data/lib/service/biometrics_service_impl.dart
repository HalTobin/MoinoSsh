import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

class BiometricsServiceImpl implements BiometricsService {
    final ServerProfileRepository _serverProfileRepository;
    final FlutterSecureStorage _secureStorage;

    // The constant name for our master vault
    static const String _masterKeyVaultId = 'ssh_app_master_encryption_key';

    static const _androidOptions = AndroidOptions.biometric(
        enforceBiometrics: true,
        biometricType: AndroidBiometricType.strongBiometricOnly
    );
    static const _iosOptions = IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
        useSecureEnclave: true,
        accessControlFlags: [AccessControlFlag.userPresence]
    );
    static const _macOsOptions = MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock,
        usesDataProtectionKeychain: true,
        useSecureEnclave: true,
        accessControlFlags: [AccessControlFlag.userPresence]
    );

    BiometricsServiceImpl({
        required ServerProfileRepository serverProfileRepository,
        FlutterSecureStorage? secureStorage,
    })  : _serverProfileRepository = serverProfileRepository,
          _secureStorage = secureStorage ?? const FlutterSecureStorage();

    @override
    Future<bool> isBiometricsSupported() async {
        if (kIsWeb) return false;
        // Basic platform support check since we want to avoid local_auth
        return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    }

    static Uint8List _generateSecureRandom(int length) {
        final random = Random.secure();
        return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
    }

    /// Retrieves the Master Key from hardware. If it doesn't exist, generates
    /// a secure 256-bit key and saves it behind biometrics.
    Future<String?> _getOrCreateMasterKey(String promptMessage) async {
        try {
            // Access Secure Storage - this will trigger the OS biometric prompt
            // because of the options set (enforceBiometrics, userPresence)
            String? masterKeyBase64 = await _secureStorage.read(
              key: _masterKeyVaultId,
              aOptions: _androidOptions,
              iOptions: _iosOptions,
              mOptions: _macOsOptions,
            );

            // If no key exists, we generate a cryptographically secure 256-bit (32 byte) key
            if (masterKeyBase64 == null || masterKeyBase64.isEmpty) {
              if (kDebugMode) print("[BiometricsServiceImpl] Generating new Master Key...");
              final newKey = _generateSecureRandom(32);
              masterKeyBase64 = base64.encode(newKey);
              await _secureStorage.write(
                key: _masterKeyVaultId,
                value: masterKeyBase64,
                aOptions: _androidOptions,
                iOptions: _iosOptions,
                mOptions: _macOsOptions,
              );
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

        return await Isolate.run(() => _encryptSync(password, masterKeyBase64));
    }

    static String? _encryptSync(String password, String masterKeyBase64) {
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
    }

    @override
    Future<String?> decryptPassword(String ciphertext) async {
        if (kDebugMode) print("[BiometricsServiceImpl] Decrypting password...");

        final masterKeyBase64 = await _getOrCreateMasterKey('Unlock your SSH Session');
        if (masterKeyBase64 == null) return null;

        return await Isolate.run(() => _decryptSync(ciphertext, masterKeyBase64));
    }

    static String? _decryptSync(String ciphertext, String masterKeyBase64) {
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
    }

    @override
    Future<void> clearKeys() async {
        if (kDebugMode) print("[BiometricsServiceImpl] Wiping Master Key and Database...");

        try {
            await _secureStorage.delete(key: _masterKeyVaultId);
        } catch (e) {
            if (kDebugMode) print('Failed to delete Master Key: $e');
        }

          // 2. Clear the database entries
          await _serverProfileRepository.deletePasswords();
    }
}
