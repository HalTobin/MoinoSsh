import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:domain/repository/preference_repository.dart';

class UpdateFileViewModeUseCase {
    UpdateFileViewModeUseCase({
        required PreferenceRepository preferenceRepository
    }): _preferenceRepository = preferenceRepository;

    final PreferenceRepository _preferenceRepository;

    Future<void> execute(String fileViewModeIdentifier) async {
        final FileViewMode fileViewMode = FileViewMode.fromIdentifier(fileViewModeIdentifier);
        await _preferenceRepository.updateFileViewMode(fileViewMode);
    }
}