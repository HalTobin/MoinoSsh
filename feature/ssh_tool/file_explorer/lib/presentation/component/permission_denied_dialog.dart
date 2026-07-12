import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class PermissionDeniedDialog extends StatelessWidget {
  final Function() onDismiss;

  const PermissionDeniedDialog({
    super.key,
    required this.onDismiss
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
            icon: LucideIcons.circleAlert,
            title: "Permission denied",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          Icon(LucideIcons.circleAlert, color: Theme.of(context).colorScheme.error, size: 48),
          Text("You don't have the permission to perform this task"),
          TextButton(
            onPressed: onDismiss,
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.error)),
            child: const Text("Close"),
          )
        ],
      )
    );
  }
}