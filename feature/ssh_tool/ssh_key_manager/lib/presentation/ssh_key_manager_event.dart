sealed class SshKeyManagerEvent {}

class ToggleRemoteKeyDeletion extends SshKeyManagerEvent {
    /// Line id, so two identical key lines can be toggled independently.
    final int id;
    ToggleRemoteKeyDeletion({required this.id});
}

class StagePublicKey extends SshKeyManagerEvent {
    final String publicKeyLine;
    StagePublicKey({required this.publicKeyLine});
}

class ApplyRemoteChanges extends SshKeyManagerEvent {}

class DiscardRemoteChanges extends SshKeyManagerEvent {}

class DismissError extends SshKeyManagerEvent {}

class ReloadRemoteKeys extends SshKeyManagerEvent {}
