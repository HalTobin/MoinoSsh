import 'package:domain/model/preferences/app_contrast.dart';
import 'package:domain/repository/preference_repository.dart';

class UpdateContrastUseCase {
    UpdateContrastUseCase({
        required PreferenceRepository preferenceRepository
    }): _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Future<void> execute(String contrastIdentifier) async {
        final AppContrast contrast = AppContrast.fromIdentifier(contrastIdentifier);
        await _preferenceRepository.updateContrast(contrast);
    }
}