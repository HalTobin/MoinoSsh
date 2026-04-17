import 'package:domain/repository/preference_repository.dart';

class ToggleKeepPasswordDuringSessionUseCase {
    ToggleKeepPasswordDuringSessionUseCase({
        required PreferenceRepository preferenceRepository
    }): _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Future<void> execute() async {
        await _preferenceRepository.toggleKeepPasswordDuringSession();
    }
}