import 'package:feature_auth/feature/my_ssh_keys/domain/ssh_key_file.dart';
import 'package:feature_auth/feature/my_ssh_keys/presentation/component/delete_ssh_key_dialog.dart';
import 'package:feature_auth/feature/my_ssh_keys/presentation/component/rename_ssh_key_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/selectable.dart';

class SshKeyItem extends StatelessWidget {
  final SshKeyFile sshKeyFile;
  final bool selected;
  final Function() onClick;

  final bool shouldEditDeleteInDialog;

  final bool editionMode;
  final Function() onEditionMode;
  final Function(String newName) onEdit;
  final Function() onDelete;

  const SshKeyItem({
    super.key,
    required this.sshKeyFile,
    required this.selected,
    required this.onClick,

    required this.shouldEditDeleteInDialog,

    required this.editionMode,
    required this.onEditionMode,
    required this.onEdit,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Selectable(
        selectionEnable: true,
        selected: selected,
        onSelect: onClick,
        child: AnimatedCrossFade(
          crossFadeState: !editionMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Row(
            children: [
              _BaseKeyItem(sshKeyFile: sshKeyFile),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.ellipsisVertical),
                onPressed: onEditionMode,
              )
            ],
          ),
          secondChild: Row(
            children: [
              _BaseKeyItem(sshKeyFile: sshKeyFile),
              const Spacer(),
              IconButton(
                icon: Icon(
                    LucideIcons.pen,
                    color: Colors.orange
                ),
                onPressed: () => showRenameDialog(context, sshKeyFile.name),
              ),
              IconButton(
                icon: Icon(
                    LucideIcons.trash2,
                    color: Colors.red
                ),
                onPressed: () => showDeleteDialog(context, sshKeyFile.name),
              ),
              IconButton(
                icon: const Icon(LucideIcons.undo),
                onPressed: onEditionMode,
              )
            ],
          ),
          /*_SshKeyItemInteractionState.editing => Row(
            children: [
              const _SshKeyFile(color: Colors.orange),

              Expanded(
                child: TextField(
                  maxLines: 1,
                  focusNode: _nameFieldFocusNode,
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: confirmRename,
                      icon: const Icon(LucideIcons.check)
                    )
                  )
                )
              ),

              IconButton(
                icon: Icon(LucideIcons.x),
                onPressed: backToIdle,
              )
            ],
          ),
          _SshKeyItemInteractionState.deleting => Row(
            children: [
              _SshKeyFile(color: Theme.of(context).colorScheme.error),

              Expanded(
                child: TextField(
                  maxLines: 1,
                  focusNode: _deleteFieldFocusNode,
                  controller: _deleteController,
                  decoration: InputDecoration(
                    hintText: "Enter: \"${widget.sshKeyFile.name}\" to confirm",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                    ),
                    suffixIcon: IconButton(
                      onPressed: confirmDeletion,
                      icon: const Icon(LucideIcons.trash2)
                    )
                  )
                )
              ),

              IconButton(
                icon: Icon(LucideIcons.x),
                onPressed: backToIdle,
              )
            ],
          ),*/
          duration: Duration(milliseconds: 300),
        )
    );
  }

  void showRenameDialog(
      BuildContext context,
      String textStartState
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return RenameSshKeyDialog(
          initialName: textStartState,
          onDismiss: () => Navigator.of(context).pop(),
          onConfirm: (newName) {
            Navigator.of(context).pop();
            onEdit(newName);
          }
        );
      }
    );
  }

  void showDeleteDialog(BuildContext context, String targetText) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteSshKeyDialog(
          textToTarget: targetText,
          onDelete: () {
            Navigator.of(context).pop();
            onDelete();
          },
          onDismiss: () => Navigator.of(context).pop(),
        );
      }
    );
  }

}

class _BaseKeyItem extends StatelessWidget {
  final SshKeyFile sshKeyFile;

  const _BaseKeyItem({
    super.key,
    required this.sshKeyFile
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
          style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
        ),
        if (sshKeyFile.secured)
          Row(
            spacing: 4,
            children: [
              const Icon(
                LucideIcons.lock,
                color: Colors.green,
                size: 16
              ),
              const Text(
                "Requires a password",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green
                )
              )
            ],
          )
      ],
    );
  }

}