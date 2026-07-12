import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';

class DeleteFileDialog extends StatelessWidget {
  final FileEntry file;
  final Function() onDelete;
  final Function() onDismiss;

  const DeleteFileDialog({
    super.key,
    required this.file,
    required this.onDelete,
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
            icon: LucideIcons.trash,
            title: "Confirm deletion",
            trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: () => onDismiss()),
          ),
          Text("You're about to delete ${file.name}, are you sure?"),
          Text(
            file.path,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
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
                  onPressed: () => onDelete(),
                  label: const Text("Delete"),
                  icon: const Icon(LucideIcons.trash),
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