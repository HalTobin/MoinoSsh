import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/biometrics_service.dart';

class DeleteKeyUseCase {
    DeleteKeyUseCase({
        required ServerProfileRepository serverProfileRepository,
        required BiometricsService biometricsService
    })
        : _serverProfileRepository = serverProfileRepository,
          _biometricsService = biometricsService;

    final ServerProfileRepository _serverProfileRepository;
    final BiometricsService _biometricsService;

    Future<void> execute() async {
        await _serverProfileRepository.deletePasswords();
        await _biometricsService.clearKeys();
    }

}