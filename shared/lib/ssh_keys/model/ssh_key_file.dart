class SshKeyFile {
    final String name;
    final String path;
    final bool secured;
    final String? algorithm;

    const SshKeyFile({
        required this.name,
        required this.path,
        required this.secured,
        this.algorithm,
    });
}
