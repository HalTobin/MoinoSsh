import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/title_header.dart';

class ConfirmDeletionModal extends StatelessWidget {
  final Function() onConfirm;
  final Function() onDismiss;

  const ConfirmDeletionModal({
    super.key,
    required this.onConfirm,
    required this.onDismiss
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    List<Widget> buttons = [
      TextButton.icon(
        onPressed: onDismiss,
        label: const Text("Cancel"),
      ),
      FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
        ),
        onPressed: onConfirm,
        icon: const Icon(LucideIcons.trash2),
        label: const Text("DELETE"),
      )
    ];

    buttons = buttons.map((widget) => Expanded(child: widget)).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 24,
      children: [
        TitleHeader(
          icon: LucideIcons.trash2,
          title: "Delete profile",
          trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: onDismiss),
        ),

        Text("You're about to delete this profile, are you sure?"),

        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: buttons,
        )
      ]
    );
  }

}