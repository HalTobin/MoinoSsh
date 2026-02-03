class UserPreferences {
    final bool biometrics;
    final bool dontAskBiometrics;

    const UserPreferences({
        required this.biometrics,
        required this.dontAskBiometrics
    });

    static UserPreferences defaultPreferences = UserPreferences(
        biometrics: false,
        dontAskBiometrics: false
    );
}