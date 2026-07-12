import 'package:flutter/material.dart';

class SettingEntryToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final bool state;
  final Function() onToggle;

  const SettingEntryToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.state,
    required this.onToggle
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        hint,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      trailing: Switch(
        // This bool value toggles the switch.
        value: state,
        activeThumbColor: Theme.of(context).colorScheme.primary,
        onChanged: (bool value) => onToggle(),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }

}