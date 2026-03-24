import 'dart:io';

import 'package:biometric_signature/biometric_signature.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:pointycastle/asymmetric/api.dart';

class BiometricsServiceImpl implements BiometricsService {
    final BiometricSignature _biometricSignature = BiometricSignature();

    @override
    Future<bool> isBiometricsSupported() async {
        if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
            final availability = await _biometricSignature.biometricAuthAvailable();
            return availability.availableBiometrics?.isNotEmpty ?? false;
        }
        return false;
    }

    @override
    Future<String?> encryptPassword(String password) async {
        if (kDebugMode) {
            print("[BiometricsServiceImpl] Encrypting and saving password...");
        }

        final bool keysExist = await _biometricSignature.biometricKeyExists();

        String? publicKey = null;

        if (kDebugMode) {
            print("[BiometricsServiceImpl] Keys exist: $keysExist");
        }
        if (!keysExist) {
            final created = await _createKeys();
            if (created == null) return null;

            publicKey = created;
        }
        else {
            final KeyInfo keyInfo;
            try {
                keyInfo = await _biometricSignature.getKeyInfo(
                    keyFormat: KeyFormat.pem,
                    checkValidity: false
                );
                publicKey = keyInfo.publicKey;
            } catch (e) {
                await clearKeys();
                if (kDebugMode) {
                    print("[BiometricsServiceImpl] ERROR Couldn't save password: ${e.toString()}");
                }
                return null;
            }
        }


        if (publicKey == null) {
            if (kDebugMode) {
                print("[BiometricsServiceImpl] ERROR Key is null");
            }
            await clearKeys();
            return null;
        }

        final crypted = _encryptRsa(password, publicKey);
        return crypted;
    }

    @override
    Future<String?> decryptPassword(String ciphertext) async {
        try {
            final result = await _biometricSignature.decrypt(
                payload: ciphertext,
                payloadFormat: PayloadFormat.base64,
                promptMessage: 'Unlock your SSH Session',
                config: DecryptConfig(allowDeviceCredentials: false),
            );

            if (result.code == BiometricError.success && result.decryptedData != null) {
                return result.decryptedData;
            } else {
                if (kDebugMode) {
                    print('Decryption failed: ${result.code}');
                }
                return null;
            }
        } catch (e) {
            if (kDebugMode) {
                print('Decryption error: $e');
            }
            return null;
        }
    }

    @override
    Future<void> clearKeys() async {
        await _biometricSignature.deleteKeys();
    }

    Future<String?> _createKeys() async {
        if (kDebugMode) {
            print("[BiometricsServiceImpl] Creating keys");
        }

        final result = await _biometricSignature.createKeys(
            keyFormat: KeyFormat.pem,
            promptMessage: 'Authenticate to enable Secure SSH',
            config: CreateKeysConfig(
                useDeviceCredentials: false,
                signatureType: SignatureType.rsa,
                setInvalidatedByBiometricEnrollment: true,
                enforceBiometric: true,
                enableDecryption: true
            ),
        );

        if (kDebugMode) {
            print("[BiometricsServiceImpl] Key creation, result: ${result.code?.toString()}");
        }

        final bool success = result.code == BiometricError.success;
        return success ? result.publicKey : null;
    }

    String _encryptRsa(String plaintext, String publicKeyStr) {
        final publicKeyPem = publicKeyStr.contains('BEGIN PUBLIC KEY')
            ? publicKeyStr
            : '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';

        final parser = enc.RSAKeyParser();
        final rsaPublicKey = parser.parse(publicKeyPem) as RSAPublicKey;
        final encrypter = enc.Encrypter(enc.RSA(publicKey: rsaPublicKey));

        final encrypted = encrypter.encrypt(plaintext);
        return encrypted.base64;
    }

}