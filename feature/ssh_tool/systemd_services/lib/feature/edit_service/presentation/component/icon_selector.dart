import 'package:collection/collection.dart';
import 'package:domain/model/moino_ssh_icon.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/icons/icon_select_dialog.dart';

class IconSelector extends StatelessWidget {
  final int currentIconId;
  final void Function(MoinoSshIcon?) onIconSelected;
  final int lines;

  const IconSelector({
    super.key,
    required this.currentIconId,
    required this.onIconSelected,
    this.lines = 1
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showSelectIconModal(context: context),
      label: Text("Select an icon"),
      icon: Icon(LucideIcons.squareMousePointer)
    );
  }

  void _showSelectIconModal({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (builder) {
        return IconSelectDialog(
          onSelect: (icon) {
            MoinoSshIcon? moinoIcon = MoinoSshIcon.values.firstWhereOrNull((sshIcon) => sshIcon.id == icon);
            if (moinoIcon != null) {
              onIconSelected(moinoIcon);
            }
            Navigator.of(context).pop();
          },
          onDismiss: () => Navigator.of(context).pop()
        );
      }
    );
  }

}