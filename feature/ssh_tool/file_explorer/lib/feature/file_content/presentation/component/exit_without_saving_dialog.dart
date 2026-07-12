import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class ExitWithoutSavingDialog extends StatelessWidget {
  final Function() onDismiss;
  final Function() onExit;

  const ExitWithoutSavingDialog({
    super.key,
    required this.onDismiss,
    required this.onExit
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
            icon: LucideIcons.saveOff,
            title: "Exit without saving",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          const Text("You have unsaved modifications. Are you sure you want to exit without saving?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Expanded(
                child: Expanded(
                  child: TextButton(
                    onPressed: onDismiss,
                    child: const Text("Cancel"),
                  )
                ),
              ),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onExit,
                  label: const Text("Exit"),
                  icon: const Icon(LucideIcons.saveOff),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.errorContainer),
                    foregroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.onErrorContainer)
                  ),
                )
              )
            ],
          )
        ],
      )
    );
  }

}