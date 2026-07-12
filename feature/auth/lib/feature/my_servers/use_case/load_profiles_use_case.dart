import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';

class LoadProfilesUseCase {
    LoadProfilesUseCase({required ServerProfileRepository serverProfileRepository})
      : _serverProfileRepository = serverProfileRepository;

    final ServerProfileRepository _serverProfileRepository;

    Future<List<ServerProfile>> execute() {
        return _serverProfileRepository.getAllProfiles();
    }
}