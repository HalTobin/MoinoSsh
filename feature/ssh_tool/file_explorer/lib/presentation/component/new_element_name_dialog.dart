import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class NewElementNameDialog extends StatelessWidget {
  final ElementType type;
  final Function(String) onCreate;
  final Function() onDismiss;

  const NewElementNameDialog({
    super.key,
    required this.type,
    required this.onCreate,
    required this.onDismiss
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return AppDialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          TitleHeader(
            icon: type.icon,
            title: type.title,
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          TextFormField(
            controller: textController,
            decoration: InputDecoration(
              labelText: type.hint,
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
                  onPressed: () => onCreate(textController.text),
                  label: Text(type.action),
                  icon: Icon(type.icon)
                )
              )
            ],
          ),
        ]
      )
    );
  }

}

enum ElementType {
  folder(
    identifier: "folder",
    title: "New folder",
    hint: "Folder name",
    action: "Create folder",
    icon: LucideIcons.folder
  ),
  file(
    identifier: "file",
    title: "New file",
    hint: "File name",
    action: "Create file",
    icon: LucideIcons.file
  );

  const ElementType({
    required this.identifier,
    required this.title,
    required this.hint,
    required this.action,
    required this.icon
  });

  final String identifier;
  final String title;
  final String hint;
  final String action;
  final IconData icon;
}