import 'package:domain/model/server_profile.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/use_case/load_ssh_file_use_case.dart';

class CheckPasswordRequirementByServerProfileIdUseCase {
    CheckPasswordRequirementByServerProfileIdUseCase({
        required ServerProfileRepository serverProfileRepository,
        required LoadSshFileUseCase loadSshFileUseCase
    })
      : _serverProfileRepository = serverProfileRepository,
        _loadSshFileUseCase = loadSshFileUseCase;

    final ServerProfileRepository _serverProfileRepository;
    final LoadSshFileUseCase _loadSshFileUseCase;

    Future<bool> execute(int serverProfileId) async {
        final ServerProfile? profile = await _serverProfileRepository.getProfileById(serverProfileId);

        if (profile != null) {
            return _loadSshFileUseCase.execute(profile.keyPath);
        }
        return false;
    }

}