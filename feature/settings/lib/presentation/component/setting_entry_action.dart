import 'package:flutter/material.dart';

class SettingEntryAction extends StatelessWidget {
  final IconData icon;
  final IconData trailingIcon;
  final String label;
  final String hint;
  final Function() onPressed;

  const SettingEntryAction({
    super.key,
    required this.icon,
    required this.trailingIcon,
    required this.label,
    required this.hint,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        hint,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      trailing: Icon(trailingIcon, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }

}