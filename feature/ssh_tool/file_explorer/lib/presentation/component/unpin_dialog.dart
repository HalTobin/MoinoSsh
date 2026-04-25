import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class UnpinDialog extends StatelessWidget {
  final Function() onDismiss;
  final Function() onUnpin;

  const UnpinDialog({
    super.key,
    required this.onDismiss,
    required this.onUnpin
  });

  @override
  Widget build(BuildContext context) {
    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.pinOff,
            title: "Unpin folder",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          const Text("Are you sure that you want to unpin this folder?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onDismiss,
                  child: const Text("Cancel"),
                )
              ),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onUnpin,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: Theme.of(context).colorScheme.onErrorContainer
                  ),
                  label: const Text("Unpin"),
                  icon: const Icon(LucideIcons.pinOff),
                )
              )
            ],
          )
        ],
      ),
    );
  }
}