import 'dart:io';

import 'package:domain/model/preferences/app_contrast.dart';
import 'package:domain/model/preferences/app_theme.dart';
import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:feature_settings/presentation/component/delete_keys_confirmation_modal.dart';
import 'package:feature_settings/presentation/component/settings/setting_entry_action.dart';
import 'package:feature_settings/presentation/component/settings/setting_entry_info.dart';
import 'package:feature_settings/presentation/component/settings/setting_entry_list.dart';
import 'package:feature_settings/presentation/component/settings/setting_entry_toggle.dart';
import 'package:feature_settings/presentation/util/app_contrast_text.dart';
import 'package:feature_settings/presentation/util/app_theme_text.dart';
import 'package:feature_settings/presentation/util/file_view_mode_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';
import 'settings_state.dart';
import 'settings_event.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsState state;
  final Function(SettingsEvent) onEvent;
  final Function() onExit;

  final Function() openSshKeyView;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onExit,
    required this.openSshKeyView
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onExit,
          icon: Icon(LucideIcons.arrowLeft)
        ),
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            children: [
              SettingEntryList(
                icon: LucideIcons.sunMoon,
                label: "App theme",
                hint: "Adjust if you prefer the app to use dark or light mode",
                selection: ListEntry(
                  identifier: state.preferences.theme.identifier,
                  text: state.preferences.theme.getText()
                ),
                entries: AppTheme.values.map((theme) => ListEntry(
                  identifier: theme.identifier,
                  text: theme.getText()
                )).toList(),
                onChanged: (value) => onEvent(UpdateTheme(value.identifier)),
              ),
              SettingEntryList(
                icon: LucideIcons.contrast,
                label: "Color contrast",
                hint: "Adjust the app's contrast",
                selection: ListEntry(
                    identifier: state.preferences.contrast.identifier,
                    text: state.preferences.contrast.getText()
                ),
                entries: AppContrast.values.map((contrast) => ListEntry(
                    identifier: contrast.identifier,
                    text: contrast.getText()
                )).toList(),
                onChanged: (value) => onEvent(UpdateContrast(value.identifier)),
              ),
              if (!Platform.isIOS) SettingEntryToggle(
                icon: LucideIcons.palette,
                label: "Dynamic colors",
                hint: "Match the app's color scheme to your device's theme",
                state: state.preferences.materialYou,
                onToggle: () => onEvent(ToggleMaterialYou()),
              ),
              SettingEntryList(
                icon: LucideIcons.columns2,
                label: "File view mode",
                hint: "Set the default view for the file explorer",
                selection: ListEntry(
                    identifier: state.preferences.fileViewMode.identifier,
                    text: state.preferences.fileViewMode.getText()
                ),
                entries: FileViewMode.values.map((contrast) => ListEntry(
                    identifier: contrast.identifier,
                    text: contrast.getText()
                )).toList(),
                onChanged: (value) => onEvent(UpdateFileViewMode(value.identifier)),
              ),
              SettingEntryToggle(
                icon: LucideIcons.eyeOff,
                label: "Show hidden files by default",
                hint: "By default hidden files and directories will be visible in the file explorer",
                state: state.preferences.showHiddenFilesByDefault,
                onToggle: () => onEvent(ToggleShowHiddenFileByDefault()),
              ),
              SettingEntryAction(
                icon: LucideIcons.folderKey,
                trailingIcon: LucideIcons.externalLink,
                label: "SSH keys",
                hint: "Manage your imported SSH keys",
                onPressed: openSshKeyView,
              ),
              SettingEntryToggle(
                icon: LucideIcons.squareAsterisk,
                label: "Remember password for the session",
                hint: "If enable, you'll be prompt only once for the session's password until you log out",
                state: state.preferences.keepPasswordDuringSession,
                onToggle: () => onEvent(ToggleKeepPasswordDuringSession()),
              ),
              SettingEntryAction(
                icon: LucideIcons.rotateCcwKey,
                trailingIcon: LucideIcons.mousePointerClick,
                label: "Delete keys and secrets",
                hint: "Will delete all data related to biometrics and quick connect",
                onPressed: () => _confirmKeyDeletionModal(context, constraints),
              ),
              SettingEntryAction(
                icon: LucideIcons.copyright,
                trailingIcon: LucideIcons.externalLink,
                label: "Licenses",
                hint: "Check the licenses, this app works thanks to all these projects",
                onPressed: () => showLicensePage(context: context)
              ),
              SettingEntryInfo(
                icon: LucideIcons.wrench,
                info: "0.0.1",
                label: "App version",
              )
            ],
          );
        }
      )
    );
  }

  void _confirmKeyDeletionModal(
    BuildContext context,
    BoxConstraints constraints
  ) {
    autoModal(
      context: context,
      constraints: constraints,
      child: DeleteKeysConfirmationModal(
        onClose: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          onEvent(DeleteKeys());
        }
      )
    );
  }

}