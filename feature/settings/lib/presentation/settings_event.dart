sealed class SettingsEvent {}

class UpdateTheme extends SettingsEvent {
    final String theme;

    UpdateTheme(this.theme);
}

class DeleteKeys extends SettingsEvent {}