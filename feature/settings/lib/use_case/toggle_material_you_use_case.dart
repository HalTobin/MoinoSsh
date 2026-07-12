import 'package:domain/repository/preference_repository.dart';

class ToggleMaterialYouUseCase {
    ToggleMaterialYouUseCase({
        required PreferenceRepository preferenceRepository
    }): _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Future<void> execute() async {
        await _preferenceRepository.toggleMaterialYou();
    }
}