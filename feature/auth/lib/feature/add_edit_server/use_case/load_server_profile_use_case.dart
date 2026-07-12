import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';

class LoadServerProfileUseCase {
    LoadServerProfileUseCase({
       required ServerProfileRepository serverProfileRepository
    })
        : _serverProfileRepository = serverProfileRepository;

    final ServerProfileRepository _serverProfileRepository;

    Future<ServerProfile?> execute(int serverProfileId) async {
        return await _serverProfileRepository.getProfileById(serverProfileId);
    }

}