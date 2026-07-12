class SshProfile {
    final String url;
    final String port;
    final String user;

    const SshProfile({
        required this.url,
        required this.port,
        required this.user,
    });

    static const SshProfile blank = SshProfile(
        url: "",
        port: "",
        user: "",
    );

    bool isBlank() {
        return url.isEmpty && port.isEmpty && user.isEmpty;
    }

    String getIdentifier() {
        return "$user@$url:$port";
    }

}