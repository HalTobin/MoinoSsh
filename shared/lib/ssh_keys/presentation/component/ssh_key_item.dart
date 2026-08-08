import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared/ssh_keys/model/ssh_key_file.dart';
import 'package:shared/ssh_keys/presentation/component/rename_ssh_key_dialog.dart';

import 'delete_ssh_key_dialog.dart';

class SshKeyItem extends StatelessWidget {
  final SshKeyFile sshKeyFile;
  final bool selected;
  final Function() onClick;
  final Function(String newName) onEdit;
  final Function() onDelete;

  const SshKeyItem({
    super.key,
    required this.sshKeyFile,
    required this.selected,
    required this.onClick,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Offset tapPosition = Offset.zero;

    return GestureDetector(
      onSecondaryTapDown: (details) {
        tapPosition = details.globalPosition;
      },
      onSecondaryTap: () => _showMenu(context, tapPosition),
      onLongPressDown: (details) {
        tapPosition = details.globalPosition;
      },
      onLongPress: () => _showMenu(context, tapPosition),
      child: Card(
        margin: EdgeInsets.zero,
        color: selected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _BaseKeyItem(sshKeyFile: sshKeyFile)),
                Builder(
                  builder: (buttonContext) {
                    return IconButton(
                      icon: const Icon(LucideIcons.ellipsisVertical),
                      onPressed: () {
                        final RenderBox button =
                            buttonContext.findRenderObject() as RenderBox;
                        final Offset position = button.localToGlobal(Offset.zero);
                        _showMenu(
                          context,
                          Offset(
                            position.dx + button.size.width,
                            position.dy + button.size.height,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context, Offset tapPosition) {
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu<_SshKeyAction>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<_SshKeyAction>(
          value: _SshKeyAction.rename,
          child: Row(
            children: [
              Icon(LucideIcons.pencil, size: 18),
              SizedBox(width: 12),
              Text('Rename'),
            ],
          ),
        ),
        PopupMenuItem<_SshKeyAction>(
          value: _SshKeyAction.delete,
          child: Row(
            children: [
              Icon(
                LucideIcons.trash2,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (!context.mounted) return;

      switch (value) {
        case _SshKeyAction.rename:
          _showRenameDialog(context, sshKeyFile.name);
        case _SshKeyAction.delete:
          _showDeleteDialog(context, sshKeyFile.name);
        case null:
          break;
      }
    });
  }

  void _showRenameDialog(BuildContext context, String textStartState) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return RenameSshKeyDialog(
          initialName: textStartState,
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onConfirm: (newName) {
            Navigator.of(dialogContext).pop();
            onEdit(newName);
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String targetText) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return DeleteSshKeyDialog(
          textToTarget: targetText,
          onDelete: () {
            Navigator.of(dialogContext).pop();
            onDelete();
          },
          onDismiss: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }
}

enum _SshKeyAction {
  rename,
  delete,
}

class _BaseKeyItem extends StatelessWidget {
  final SshKeyFile sshKeyFile;

  const _BaseKeyItem({
    required this.sshKeyFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sshKeyFile.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (sshKeyFile.secured)
          const Row(
            spacing: 4,
            children: [
              Icon(
                LucideIcons.lock,
                color: Colors.green,
                size: 16,
              ),
              Text(
                "Requires a password",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
