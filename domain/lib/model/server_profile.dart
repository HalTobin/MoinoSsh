class ServerProfile {
    final int id;

    final String? name;

    final String url;
    final String port;
    final String user;
    final String keyPath;

    final String? securedSshKeyPassword;
    final String? securedSessionPassword;

    const ServerProfile({
        required this.id,
        required this.name,
        required this.url,
        required this.port,
        required this.user,
        required this.keyPath,
        required this.securedSshKeyPassword,
        required this.securedSessionPassword
    });

    String getIdentifier() {
        return "$user@$url:$port";
    }

    static const ServerProfile empty = ServerProfile(
        id: -1,
        name: null,
        url: "",
        port: "",
        user: "",
        keyPath: "",
        securedSshKeyPassword: null,
        securedSessionPassword: null
    );

    @override
    bool operator ==(Object other) {
        if (identical(this, other)) return true;

        return other is ServerProfile &&
            other.id == id &&
            other.name == name &&
            other.url == url &&
            other.port == port &&
            other.user == user &&
            other.keyPath == keyPath &&
            other.securedSshKeyPassword == securedSshKeyPassword &&
            other.securedSessionPassword == securedSessionPassword;
    }

    @override
    int get hashCode {
        return Object.hash(id, name, url, port, user, keyPath, securedSshKeyPassword, securedSessionPassword);
    }
}

class NewServerProfile {
    final String? name;
    final String url;
    final String port;
    final String user;
    final String keyPath;

    NewServerProfile({
        required this.name,
        required this.url,
        required this.port,
        required this.user,
        required this.keyPath
    });
}

class EditServerProfile {
    final int id;
    final String? name;
    final String url;
    final String port;
    final String user;
    final String keyPath;
    final String? securedSshKeyPassword;
    final String? securedSessionPassword;

    EditServerProfile({
        required this.id,
        required this.name,
        required this.url,
        required this.port,
        required this.user,
        required this.keyPath,
        required this.securedSshKeyPassword,
        required this.securedSessionPassword
    });
}