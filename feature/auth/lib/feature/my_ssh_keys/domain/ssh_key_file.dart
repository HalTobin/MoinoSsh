class SshKeyFile {
    final String name;
    final String path;
    final bool secured;

    const SshKeyFile({
        required this.name,
        required this.path,
        required this.secured
    });
}