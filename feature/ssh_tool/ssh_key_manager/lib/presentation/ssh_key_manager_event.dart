sealed class SshKeyManagerEvent {}

class SwitchTab extends SshKeyManagerEvent {
    final int tabIndex;
    SwitchTab({required this.tabIndex});
}

class ToggleRemoteKeyDeletion extends SshKeyManagerEvent {
    final String line;
    ToggleRemoteKeyDeletion({required this.line});
}

class GenerateKeyPair extends SshKeyManagerEvent {
    final String name;
    final String? password;
    GenerateKeyPair({required this.name, this.password});
}

class ApplyRemoteChanges extends SshKeyManagerEvent {}

class DiscardRemoteChanges extends SshKeyManagerEvent {}

class DismissError extends SshKeyManagerEvent {}

class ReloadRemoteKeys extends SshKeyManagerEvent {}
