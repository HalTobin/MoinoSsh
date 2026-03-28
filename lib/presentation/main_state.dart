import 'package:domain/model/ssh/ssh_profile.dart';

class MainState {
    final bool isConnected;
    final SshProfile profile;
    final bool biometricsAvailable;
    final bool sessionBiometricsAvailable;

    MainState({
        this.isConnected = false,
        this.profile = SshProfile.blank,
        this.biometricsAvailable = false,
        this.sessionBiometricsAvailable = false
    });

    MainState copyWith({
        bool? isConnected,
        SshProfile? profile,
        bool? biometricsAvailable,
        bool? sessionBiometricsAvailable
    }) {
        return MainState(
            isConnected: isConnected ?? this.isConnected,
            profile: profile ?? this.profile,
            biometricsAvailable: biometricsAvailable ?? this.biometricsAvailable,
            sessionBiometricsAvailable: sessionBiometricsAvailable ?? this.sessionBiometricsAvailable
        );
    }
}