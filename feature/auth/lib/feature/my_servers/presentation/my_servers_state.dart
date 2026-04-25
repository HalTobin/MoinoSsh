import 'package:ui/state/omit.dart';

import '../model/server_profile_ui.dart';

class MyServersState {
    final bool loading;
    final List<ServerProfileUi> servers;
    final bool passwordError;

    final bool sshPasswordRequired;
    final bool biometricsAvailable;

    final bool connecting;

    MyServersState({
        this.loading = true,
        this.servers = const [],
        this.passwordError = false,

        this.sshPasswordRequired = false,
        this.biometricsAvailable = false,

        this.connecting = false
    });

    MyServersState copyWith({
        Defaulted<bool>? loading = const Omit(),
        Defaulted<List<ServerProfileUi>>? servers = const Omit(),
        Defaulted<bool>? passwordError = const Omit(),

        Defaulted<bool>? sshPasswordRequired = const Omit(),
        Defaulted<bool>? biometricsAvailable = const Omit(),

        Defaulted<bool>? connecting = const Omit()
    }) {
        return MyServersState(
            loading: loading is Omit ? this.loading : loading as bool,
            servers: servers is Omit ? this.servers : servers as List<ServerProfileUi>,
            passwordError: passwordError is Omit ? this.passwordError : passwordError as bool,

            sshPasswordRequired: sshPasswordRequired is Omit ? this.sshPasswordRequired : sshPasswordRequired as bool,
            biometricsAvailable: biometricsAvailable is Omit ? this.biometricsAvailable : biometricsAvailable as bool,

            connecting: connecting is Omit ? this.connecting : connecting as bool
        );
    }

}