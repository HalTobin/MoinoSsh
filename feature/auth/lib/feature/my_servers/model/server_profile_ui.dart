class ServerProfileUi {
    final int id;

    final String? name;

    final String url;
    final String port;
    final String user;
    final String keyPath;

    final String? securedSshKeyPassword;
    final String? securedSessionPassword;
    final bool keyRequiresPassword;

    const ServerProfileUi({
        required this.id,
        required this.name,
        required this.url,
        required this.port,
        required this.user,
        required this.keyPath,
        required this.securedSshKeyPassword,
        required this.securedSessionPassword,
        required this.keyRequiresPassword
    });

    String getIdentifier() {
        return "$user@$url:$port";
    }
}