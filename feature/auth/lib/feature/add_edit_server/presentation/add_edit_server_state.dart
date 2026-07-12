import 'package:domain/model/server_profile.dart';
import 'package:ui/state/omit.dart';

class AddEditServerState {
    final int? serverProfileId;
    final ServerProfile? serverProfile;
    final bool loading;
    final bool passwordRequired;
    final String sshFilePath;

    AddEditServerState({
        this.serverProfileId = null,
        this.serverProfile = null,
        this.loading = false,
        this.passwordRequired = false,
        this.sshFilePath = ""
    });

    AddEditServerState copyWith({
        Defaulted<int?> serverProfileId = const Omit(),
        Defaulted<ServerProfile?> serverProfile = const Omit(),
        Defaulted<bool> loading = const Omit(),
        Defaulted<bool> passwordRequired = const Omit(),
        Defaulted<String> sshFilePath = const Omit()
    }) {
        return AddEditServerState(
            serverProfileId: serverProfileId is Omit ? this.serverProfileId : serverProfileId as int?,
            serverProfile: serverProfile is Omit ? this.serverProfile : serverProfile as ServerProfile?,
            loading: loading is Omit ? this.loading : loading as bool,
            passwordRequired: passwordRequired is Omit ? this.passwordRequired : passwordRequired as bool,
            sshFilePath: sshFilePath is Omit ? this.sshFilePath : sshFilePath as String
        );
    }

}