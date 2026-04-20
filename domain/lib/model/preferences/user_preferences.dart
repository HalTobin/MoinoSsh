import 'package:domain/model/preferences/app_contrast.dart';
import 'package:domain/model/preferences/app_theme.dart';
import 'package:domain/model/preferences/file_view_mode.dart';

class UserPreferences {
    final AppTheme theme;
    final AppContrast contrast;
    final bool materialYou;
    final bool keepPasswordDuringSession;
    final bool showHiddenFilesByDefault;
    final FileViewMode fileViewMode;

    const UserPreferences({
        required this.theme,
        required this.contrast,
        required this.materialYou,
        required this.keepPasswordDuringSession,
        required this.showHiddenFilesByDefault,
        required this.fileViewMode
    });

    static const UserPreferences defaultPreferences = UserPreferences(
        theme: AppTheme.auto,
        contrast: AppContrast.low,
        materialYou: true,
        keepPasswordDuringSession: false,
        showHiddenFilesByDefault: false,
        fileViewMode: FileViewMode.grid
    );
}