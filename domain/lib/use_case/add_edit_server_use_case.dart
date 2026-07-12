import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';

class AddEditServerUseCase {
    AddEditServerUseCase({
        required ServerProfileRepository serverProfileRepository
    })
       : _serverProfileRepository = serverProfileRepository;

    final ServerProfileRepository _serverProfileRepository;

    Future<int?> execute(AddEditServer server) async {
        if (server.id != null) {
            final EditServerProfile editServer = EditServerProfile(
                id: server.id!,
                name: server.name,
                url: server.url,
                port: server.port,
                user: server.user,
                keyPath: server.sshFilePath,
                securedSshKeyPassword: server.securedSshKeyPassword,
                securedSessionPassword: server.securedSessionPassword
            );
            final bool updated = await _serverProfileRepository.updateProfile(editServer);
            if (updated) {
                return server.id;
            } else {
                return null;
            }
        }
        else {
          final NewServerProfile newServer = NewServerProfile(
              name: server.name,
              url: server.url,
              port: server.port,
              user: server.user,
              keyPath: server.sshFilePath
          );
          return _serverProfileRepository.saveProfile(newServer);
        }
    }

}

class AddEditServer {
    final int? id;
    final String? name;
    final String url;
    final String port;
    final String user;
    final String sshFilePath;
    final String? securedSshKeyPassword;
    final String? securedSessionPassword;

    AddEditServer({
        this.id,
        this.name,
        required this.url,
        required this.port,
        required this.user,
        required this.sshFilePath,
        required this.securedSshKeyPassword,
        required this.securedSessionPassword
    });
}