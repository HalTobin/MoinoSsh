import 'package:domain/model/ssh/ssh_profile.dart';

class MainState {
    final bool isConnected;
    final SshProfile profile;
    final bool sessionBiometricsAvailable;

    MainState({
        this.isConnected = false,
        this.profile = SshProfile.blank,
        this.sessionBiometricsAvailable = false
    });

    MainState copyWith({
        bool? isConnected,
        SshProfile? profile,
        bool? sessionBiometricsAvailable
    }) {
        return MainState(
            isConnected: isConnected ?? this.isConnected,
            profile: profile ?? this.profile,
            sessionBiometricsAvailable: sessionBiometricsAvailable ?? this.sessionBiometricsAvailable
        );
    }
}