import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class RenameSshKeyDialog extends StatelessWidget {
  final String initialName;
  final Function(String) onConfirm;
  final Function() onDismiss;

  const RenameSshKeyDialog({
    super.key,
    required this.initialName,
    required this.onDismiss,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController(text: initialName);

    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.fileKey,
            title: "Rename key",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: onDismiss)
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Rename",
              border: const OutlineInputBorder()
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(onPressed: onDismiss, child: const Text("Cancel"))
              ),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => onConfirm(_nameController.text),
                  icon: const Icon(LucideIcons.pen),
                  label: const Text("Rename")
                )
              )
            ],
          )
        ],
      )
    );
  }

}