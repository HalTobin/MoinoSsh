import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';

class SettingEntryList extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final ListEntry selection;
  final List<ListEntry> entries;
  final Function(ListEntry) onChanged;

  const SettingEntryList({
    super.key,
    required this.icon,
    required this.selection,
    required this.entries,
    required this.label,
    required this.hint,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showSelectionDialog(context),
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        hint,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      trailing: SettingEntryListButton(
        title: label,
        selection: selection,
        entries: entries,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AppDialogLayout(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Text(label, style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: selection.identifier,
                onChanged: (value) {
                  final newEntry = entries.firstWhere((e) => e.identifier == value);
                  onChanged(newEntry);
                  Navigator.pop(context);
                },
                child: Column(
                  children: entries.map((entry) => RadioListTile<String>(
                    value: entry.identifier,
                    title: Text(entry.text),
                  )).toList(),
                ),
              )
            ],
          )
        );
      }
    );
  }

}

class SettingEntryListButton extends StatelessWidget {
  final String title;
  final ListEntry selection;
  final List<ListEntry> entries;

  const SettingEntryListButton({
    super.key,
    required this.title,
    required this.selection,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selection.text.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        )
      ),
    );
  }

}

class ListEntry {
  final String identifier;
  final String text;

  const ListEntry({required this.identifier, required this.text});
}