import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class RenameDialog extends StatelessWidget {
  final String? currentAlias;
  final Function() onDismiss;
  final Function() onUnpin;
  final Function(String) onRename;

  const RenameDialog({
    super.key,
    required this.currentAlias,
    required this.onDismiss,
    required this.onUnpin,
    required this.onRename
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: currentAlias);

    return AppDialogLayout(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.folderPen,
            title: "Rename folder",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss),
          ),
          TextField(
            controller: textController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              TextButton.icon(
                onPressed: onUnpin,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error
                ),
                label: const Text("Unpin"),
                icon: const Icon(LucideIcons.pinOff),
              ),
              FilledButton.icon(
                onPressed: () => onRename(textController.text),
                label: const Text("Rename"),
                icon: const Icon(LucideIcons.pen)
              )
            ],
          )
        ],
      )
    );
  }
}