import 'package:domain/repository/preference_repository.dart';

class CheckDefaultShowHiddenUseCase {
    final PreferenceRepository preferenceRepository;

    const CheckDefaultShowHiddenUseCase({
        required this.preferenceRepository
    });

    Future<bool> execute() async {
        final preferences = await preferenceRepository.getUserPreferences();
        return preferences.showHiddenFilesByDefault;
    }
}