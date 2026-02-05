abstract interface class BiometricsService {

    Future<bool> isBiometricsSupported();

    Future<String?> encryptPassword(String password);

    Future<String?> decryptPassword(String ciphertext);

    Future<void> clearKeys();

}