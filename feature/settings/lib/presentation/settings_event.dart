sealed class SettingsEvent {}

class UpdateTheme extends SettingsEvent {
    final String theme;

    UpdateTheme(this.theme);
}

class UpdateContrast extends SettingsEvent {
    final String contrast;

    UpdateContrast(this.contrast);
}

class ToggleMaterialYou extends SettingsEvent {}

class ToggleKeepPasswordDuringSession extends SettingsEvent {}

class ToggleShowHiddenFileByDefault extends SettingsEvent {}

class UpdateFileViewMode extends SettingsEvent {
    final String fileViewMode;

    UpdateFileViewMode(this.fileViewMode);
}

class DeleteKeys extends SettingsEvent {}