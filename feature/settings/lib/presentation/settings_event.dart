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

class DeleteKeys extends SettingsEvent {}