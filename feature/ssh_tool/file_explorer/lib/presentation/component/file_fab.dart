import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/expandable_fab.dart';

class FileFab extends StatelessWidget {
  final Function(FileFabAction) onAction;

  const FileFab({
    super.key,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      heroTagPrefix: 'file_explorer',
      label: 'Add',
      actions: FileFabAction.values
          .map(
            (action) => ExpandableFabAction(
              id: action.identifier,
              label: action.actionText,
              icon: action.actionIcon,
            ),
          )
          .toList(),
      onAction: (action) {
        final match = FileFabAction.values.firstWhere(
          (value) => value.identifier == action.id,
        );
        onAction(match);
      },
    );
  }
}

enum FileFabAction {
  newFile(
    position: 0,
    identifier: "new_file",
    actionText: "New file",
    actionIcon: LucideIcons.filePlus,
  ),
  newFolder(
    position: 1,
    identifier: "new_folder",
    actionText: "New folder",
    actionIcon: LucideIcons.folderPlus,
  ),
  uploadFile(
    position: 2,
    identifier: "upload_file",
    actionText: "Upload file",
    actionIcon: LucideIcons.upload,
  );

  const FileFabAction({
    required this.position,
    required this.identifier,
    required this.actionText,
    required this.actionIcon,
  });

  final int position;
  final String identifier;
  final String actionText;
  final IconData actionIcon;
}
