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
    GenerateKeyPair({required this.name});
}

class ApplyRemoteChanges extends SshKeyManagerEvent {}

class DiscardRemoteChanges extends SshKeyManagerEvent {}

class DismissError extends SshKeyManagerEvent {}

class ReloadRemoteKeys extends SshKeyManagerEvent {}
