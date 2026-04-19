sealed class AddEditServerEvent {}

class LoadServerProfile extends AddEditServerEvent {
    final int serverProfileId;
    LoadServerProfile({required this.serverProfileId});
}

class SaveEditServer extends AddEditServerEvent {
    final int? serverProfileId;
    final String name;
    final String user;
    final String url;
    final String port;
    final String sshFilePath;

    SaveEditServer({
        this.serverProfileId,
        required this.name,
        required this.user,
        required this.url,
        required this.port,
        required this.sshFilePath,
    });
}

class LoadSshFile extends AddEditServerEvent {
    final String sshFilePath;
    LoadSshFile({required this.sshFilePath});
}

class DeleteProfile extends AddEditServerEvent {}