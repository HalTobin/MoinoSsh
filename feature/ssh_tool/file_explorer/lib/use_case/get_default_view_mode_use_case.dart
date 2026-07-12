import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:domain/repository/preference_repository.dart';

class GetDefaultViewModeUseCase {
    final PreferenceRepository preferenceRepository;

    const GetDefaultViewModeUseCase({required this.preferenceRepository});

    Future<FileViewMode> execute() async {
        final preferences = await preferenceRepository.getUserPreferences();
        return preferences.fileViewMode;
    }

}