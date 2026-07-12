import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SaveDeleteButtons extends StatelessWidget {
  final bool isNarrow;
  final Function() onSave;
  final Function()? onDelete;

  const SaveDeleteButtons({
    super.key,
    required this.isNarrow,
    required this.onSave,
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    List<Widget> children = [
      if (onDelete != null)
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.error,
          ),
          onPressed: onDelete,
          icon: const Icon(LucideIcons.trash),
          label: const Text("Delete"),
        ),
      FilledButton.icon(
        onPressed: onSave,
        icon: const Icon(LucideIcons.save),
        label: const Text("SAVE"),
      ),
    ];

    if (isNarrow) {
      children = children.map((widget) => Expanded(child: widget)).toList();
    }

    return Row(
      mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: children
    );
  }

}