import 'package:domain/model/ssh_connect_fields.dart';

class DirectAuthState {
    final bool loading;
    final String sshFilePath;
    final bool passwordRequired;
    final List<SshConnectFields> wrongFields;
    final String globalError;

    DirectAuthState({
        this.loading = false,
        this.sshFilePath = "",
        this.passwordRequired = false,
        this.wrongFields = const [],
        this.globalError = ""
    });

    DirectAuthState copyWith({
        bool? loading,
        String? sshFilePath,
        bool? passwordRequired,
        List<SshConnectFields>? wrongFields,
        String? globalError
    }) {
        return DirectAuthState(
            loading: loading ?? this.loading,
            sshFilePath: sshFilePath ?? this.sshFilePath,
            passwordRequired: passwordRequired ?? this.passwordRequired,
            wrongFields: wrongFields ?? this.wrongFields,
            globalError: globalError ?? this.globalError
        );
    }

}