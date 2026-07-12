import 'package:flutter/material.dart';

class SettingEntryInfo extends StatelessWidget {
  final IconData icon;
  final String info;
  final String label;
  final String? hint;

  const SettingEntryInfo({
    super.key,
    required this.icon,
    required this.info,
    required this.label,
    this.hint = null
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: hint != null
          ? Text(hint ?? "null", style: TextStyle(color: Theme.of(context).hintColor))
          : null,
      trailing: Text(info, style: Theme.of(context).textTheme.bodyLarge),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }

}