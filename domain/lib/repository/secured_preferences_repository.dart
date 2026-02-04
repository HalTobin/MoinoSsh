abstract interface class SecuredPreferencesRepository {

    Future<bool> isBiometricsSupported();

    Future<String?> getUserKey();

    Future<void> writeUserKey(String key);

}