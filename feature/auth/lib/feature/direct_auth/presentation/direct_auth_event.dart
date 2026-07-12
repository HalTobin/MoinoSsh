sealed class DirectAuthEvent {}

class LoadSshFile extends DirectAuthEvent {
    final String sshFilePath;
    LoadSshFile({required this.sshFilePath});
}

class Connect extends DirectAuthEvent {
    final String user;
    final String serverUrl;
    final String serverPort;
    final String sshFilePath;
    final String? password;
    Connect({
        required this.user,
        required this.serverUrl,
        required this.serverPort,
        required this.sshFilePath,
        required this.password,
    });
}

class ClearError extends DirectAuthEvent {}