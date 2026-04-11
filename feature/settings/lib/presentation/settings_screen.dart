import 'package:feature_settings/presentation/component/setting_entry_action.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'settings_state.dart';
import 'settings_event.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsState state;
  final Function(SettingsEvent) onEvent;
  final Function() onExit;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onExit
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onExit,
          icon: Icon(LucideIcons.arrowLeft)
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          SettingEntryAction(
            icon: LucideIcons.rotateCcwKey,
            trailingIcon: LucideIcons.mousePointerClick,
            label: "Delete keys and secrets",
            hint: "Will delete all data related to biometrics and quick connect",
            onPressed: () => onEvent(DeleteKeys()),
          )
        ],
      )
    );
  }

}