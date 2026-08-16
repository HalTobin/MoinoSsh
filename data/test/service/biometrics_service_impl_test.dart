import 'dart:convert';
import 'dart:typed_data';

import 'package:data/service/biometrics_service_impl.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockServerProfileRepository extends Mock implements ServerProfileRepository {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late MockServerProfileRepository mockRepository;
  late MockFlutterSecureStorage mockStorage;
  late MockLocalAuthentication mockAuth;
  late BiometricsServiceImpl service;

  setUp(() {
    mockRepository = MockServerProfileRepository();
    mockStorage = MockFlutterSecureStorage();
    mockAuth = MockLocalAuthentication();
    service = BiometricsServiceImpl(
      serverProfileRepository: mockRepository,
      secureStorage: mockStorage,
      localAuth: mockAuth,
    );

    // Register fallback for mocktail
    registerFallbackValue(const AuthenticationOptions());
    registerFallbackValue(const AndroidOptions());
    registerFallbackValue(const IOSOptions());
  });

  group('isBiometricsSupported', () {
    test('returns true when supported', () async {
      when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
      when(() => mockAuth.isDeviceSupported()).thenAnswer((_) async => true);

      final result = await service.isBiometricsSupported();
      expect(result, isTrue);
    });

    test('returns false when not supported', () async {
      when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => false);
      when(() => mockAuth.isDeviceSupported()).thenAnswer((_) async => false);

      final result = await service.isBiometricsSupported();
      expect(result, isFalse);
    });
  });

  group('Encryption/Decryption', () {
    const testPassword = 'my-secret-password';
    final masterKey = Uint8List.fromList(List.generate(32, (i) => i));
    final masterKeyBase64 = base64.encode(masterKey);

    setUp(() {
      when(() => mockAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => true);
    });

    test('encryptPassword generates a key if none exists and encrypts', () async {
      when(() => mockStorage.read(
            key: any(named: 'key'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => null);
      
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => {});

      final encrypted = await service.encryptPassword(testPassword);

      expect(encrypted, isNotNull);
      expect(encrypted!.contains(':'), isTrue);
      
      // Verify key generation and storage
      verify(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).called(1);
    });

    test('decryptPassword uses existing key to decrypt', () async {
      when(() => mockStorage.read(
            key: any(named: 'key'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => masterKeyBase64);

      // Encrypt first to get valid ciphertext
      final encrypted = await service.encryptPassword(testPassword);
      
      // Now decrypt
      final decrypted = await service.decryptPassword(encrypted!);
      
      expect(decrypted, testPassword);
    });

    test('encryption is consistent with decryption', () async {
      when(() => mockStorage.read(
            key: any(named: 'key'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => masterKeyBase64);

      final encrypted = await service.encryptPassword(testPassword);
      final decrypted = await service.decryptPassword(encrypted!);
      
      expect(decrypted, testPassword);
    });
  });

  group('clearKeys', () {
    test('deletes key and clears repository passwords', () async {
      when(() => mockStorage.delete(
            key: any(named: 'key'),
            aOptions: any(named: 'aOptions'),
            iOptions: any(named: 'iOptions'),
          )).thenAnswer((_) async => {});
      when(() => mockRepository.deletePasswords()).thenAnswer((_) async => {});

      await service.clearKeys();

      verify(() => mockStorage.delete(key: any(named: 'key'))).called(1);
      verify(() => mockRepository.deletePasswords()).called(1);
    });
  });
}
