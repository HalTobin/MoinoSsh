class SshSecretEntry {
    final String identifier;
    final String sshKeyPassword;
    final String? userPassword;

    SshSecretEntry({
        required this.identifier,
        required this.sshKeyPassword,
        this.userPassword
    });
}