import 'package:domain/model/server_profile.dart';
import 'package:ui/state/omit.dart';

class MyServersState {
    final bool loading;
    final List<ServerProfile> servers;
    final bool passwordError;

    final bool sshPasswordRequired;
    final int? selectedServerId;
    final bool selectedServerHasBiometrics;
    final bool biometricsAvailable;

    final int? editionServerId;
    final bool connecting;

    MyServersState({
        this.loading = true,
        this.servers = const [],
        this.passwordError = false,

        this.sshPasswordRequired = false,
        this.selectedServerId = null,
        this.selectedServerHasBiometrics = false,
        this.biometricsAvailable = false,

        this.editionServerId = null,
        this.connecting = false
    });

    MyServersState copyWith({
        Defaulted<bool>? loading = const Omit(),
        Defaulted<List<ServerProfile>>? servers = const Omit(),
        Defaulted<bool>? passwordError = const Omit(),

        Defaulted<bool>? sshPasswordRequired = const Omit(),
        Defaulted<int?>? selectedServerId = const Omit(),
        Defaulted<bool>? selectedServerHasBiometrics = const Omit(),
        Defaulted<bool>? biometricsAvailable = const Omit(),

        Defaulted<int?>? editionServerId = const Omit(),
        Defaulted<bool>? connecting = const Omit()
    }) {
        return MyServersState(
            loading: loading is Omit ? this.loading : loading as bool,
            servers: servers is Omit ? this.servers : servers as List<ServerProfile>,
            passwordError: passwordError is Omit ? this.passwordError : passwordError as bool,

            sshPasswordRequired: sshPasswordRequired is Omit ? this.sshPasswordRequired : sshPasswordRequired as bool,
            selectedServerId: selectedServerId is Omit ? this.selectedServerId : selectedServerId as int?,
            selectedServerHasBiometrics: selectedServerHasBiometrics is Omit ? this.selectedServerHasBiometrics : selectedServerHasBiometrics as bool,
            biometricsAvailable: biometricsAvailable is Omit ? this.biometricsAvailable : biometricsAvailable as bool,

            editionServerId: editionServerId is Omit ? this.editionServerId : editionServerId as int?,
            connecting: connecting is Omit ? this.connecting : connecting as bool
        );
    }

}