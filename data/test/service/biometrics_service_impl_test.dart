import 'dart:convert';
import 'dart:typed_data';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:data/service/biometrics_service_impl.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockServerProfileRepository extends Mock implements ServerProfileRepository {}
class MockBiometricStorage extends Mock implements BiometricStorage {}
class MockBiometricStorageFile extends Mock implements BiometricStorageFile {}

void main() {
  late MockServerProfileRepository mockRepository;
  late MockBiometricStorage mockStorage;
  late MockBiometricStorageFile mockFile;
  late BiometricsServiceImpl service;

  setUp(() {
    mockRepository = MockServerProfileRepository();
    mockStorage = MockBiometricStorage();
    mockFile = MockBiometricStorageFile();
    service = BiometricsServiceImpl(
      serverProfileRepository: mockRepository,
      biometricStorage: mockStorage,
    );

    // Register fallback for mocktail
    registerFallbackValue(StorageFileInitOptions());
    registerFallbackValue(PromptInfo(
      iosPromptInfo: const IosPromptInfo(),
      androidPromptInfo: const AndroidPromptInfo(title: 'test'),
    ));
  });

  group('isBiometricsSupported', () {
    test('returns true when success', () async {
      when(() => mockStorage.canAuthenticate())
          .thenAnswer((_) async => CanAuthenticateResponse.success);

      final result = await service.isBiometricsSupported();
      expect(result, isTrue);
    });

    test('returns false when not supported', () async {
      when(() => mockStorage.canAuthenticate())
          .thenAnswer((_) async => CanAuthenticateResponse.errorHwUnavailable);

      final result = await service.isBiometricsSupported();
      expect(result, isFalse);
    });
  });

  group('Encryption/Decryption', () {
    const testPassword = 'my-secret-password';
    final masterKey = Uint8List.fromList(List.generate(32, (i) => i));
    final masterKeyBase64 = base64.encode(masterKey);

    setUp(() {
      when(() => mockStorage.getStorage(
            any(),
            options: any(named: 'options'),
            promptInfo: any(named: 'promptInfo'),
          )).thenAnswer((_) async => mockFile);
    });

    test('encryptPassword generates a key if none exists and encrypts', () async {
      when(() => mockFile.read()).thenAnswer((_) async => null);
      when(() => mockFile.write(any())).thenAnswer((_) async => {});

      final encrypted = await service.encryptPassword(testPassword);

      expect(encrypted, isNotNull);
      expect(encrypted!.contains(':'), isTrue);
      
      // Verify key generation and storage
      verify(() => mockFile.write(any())).called(1);
    });

    test('decryptPassword uses existing key to decrypt', () async {
      when(() => mockFile.read()).thenAnswer((_) async => masterKeyBase64);

      // Encrypt first to get valid ciphertext
      final encrypted = await service.encryptPassword(testPassword);
      
      // Now decrypt
      final decrypted = await service.decryptPassword(encrypted!);
      
      expect(decrypted, testPassword);
    });

    test('encryption is consistent with decryption', () async {
      when(() => mockFile.read()).thenAnswer((_) async => masterKeyBase64);

      final encrypted = await service.encryptPassword(testPassword);
      final decrypted = await service.decryptPassword(encrypted!);
      
      expect(decrypted, testPassword);
    });
  });

  group('clearKeys', () {
    test('deletes vault and clears repository passwords', () async {
      when(() => mockStorage.getStorage(any())).thenAnswer((_) async => mockFile);
      when(() => mockFile.delete()).thenAnswer((_) async => {});
      when(() => mockRepository.deletePasswords()).thenAnswer((_) async => {});

      await service.clearKeys();

      verify(() => mockFile.delete()).called(1);
      verify(() => mockRepository.deletePasswords()).called(1);
    });
  });
}
