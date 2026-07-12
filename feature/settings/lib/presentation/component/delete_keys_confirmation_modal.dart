import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/title_header.dart';

class DeleteKeysConfirmationModal extends StatelessWidget {
  final Function() onClose;
  final Function() onConfirm;

  const DeleteKeysConfirmationModal({
    super.key,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 386,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.rotateCcwKey,
            title: "Delete keys",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: onClose),
          ),
          const Text(
            "Are you sure? This will delete the keys that allow the usage of your pin/biometrics when a password is needed.",
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: onClose,
                child: const Text("Cancel"),
              ),
              FilledButton.tonal(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                child: const Text('Delete'),
              )
            ],
          ),
        ],
      ),
    );
  }
}