import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class RenameDialog extends StatelessWidget {
  final String? currentAlias;
  final Function() onDismiss;
  final Function(String) onRename;

  const RenameDialog({
    super.key,
    required this.currentAlias,
    required this.onDismiss,
    required this.onRename
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: currentAlias);

    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.folderPen,
            title: "Rename folder",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          TextFormField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Alias",
              border: const OutlineInputBorder(),
            ),
          ),
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
                  onPressed: () => onRename(textController.text),
                  label: const Text("Rename"),
                  icon: const Icon(LucideIcons.pen)
                )
              )
            ],
          )
        ],
      )
    );
  }
}