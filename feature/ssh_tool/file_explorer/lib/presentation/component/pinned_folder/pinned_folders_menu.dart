import 'package:domain/model/moino_ssh_icon.dart';
import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:feature_file_explorer/presentation/component/rename_dialog.dart';
import 'package:feature_file_explorer/presentation/component/unpin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/icons/icon_select_dialog.dart';
import 'package:ui/icons/moino_ssh_icon_data.dart';

class PinnedFoldersMenu extends StatelessWidget {
  final String? currentPath;
  final List<PinnedFolder> folders;
  final Function(String) onFolderTap;
  final Function(String) onUnpin;
  final Function(String, String) onFolderRename;
  final Function(String, int?) onIconEdit;

  const PinnedFoldersMenu({
    super.key,
    required this.currentPath,
    required this.folders,
    required this.onFolderTap,
    required this.onUnpin,
    required this.onFolderRename,
    required this.onIconEdit
  });

  List<Widget> buildMenu({
    required PinnedFolder folder,
    required Function(PinnedFolder) onEdit,
    required Function(PinnedFolder) onEditIcon,
    required Function(PinnedFolder) onUnpin
  }) {
    return [
      MenuItemButton(
        onPressed: () => onEdit(folder),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: const Text("Rename"),
        ),
      ),
      MenuItemButton(
        onPressed: () => onEditIcon(folder),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: const Text("Edit icon"),
        ),
      ),
      MenuItemButton(
        onPressed: () => onUnpin(folder),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: const Text("Unpin"),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final sortedFolders = List<PinnedFolder>.from(folders)
      ..sort((a, b) => a.customIndex.compareTo(b.customIndex));

    void renameRequest({required String path, required String? alias}) {
      showDialog(
        context: context,
        builder: (context) {
          return RenameDialog(
            currentAlias: alias,
            onDismiss: () => Navigator.of(context).pop(),
            onRename: (newAlias) {
              onFolderRename(path, newAlias);
              Navigator.of(context).pop();
            }
          );
        }
      );
    }

    void editIconRequest({required String path, required int? iconId}) {
      showDialog(
        context: context,
        builder: (context) {
          return IconSelectDialog(
            initialSelection: iconId,
            onSelect: (newIcon) {
              onIconEdit(path, newIcon);
              Navigator.of(context).pop();
            },
            onDismiss: () => Navigator.of(context).pop()
          );
        }
      );
    }

    void unpinRequest({required String path}) {
      showDialog(
        context: context,
        builder: (context) {
          return UnpinDialog(
            onDismiss: () => Navigator.of(context).pop(),
            onUnpin: () {
              onUnpin(path);
              Navigator.of(context).pop();
            }
          );
        }
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: sortedFolders.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final folder = sortedFolders[index];

          final String title = folder.alias ?? folder.path;
          final String? subtitle = folder.alias != null ? folder.path : null;
          final bool isSelected = currentPath == folder.path;
          final IconData icon = folder.iconId != null ? MoinoSshIcon.findById(folder.iconId)?.icon ?? LucideIcons.folder : LucideIcons.folder;

          return MenuAnchor(
            alignmentOffset: Offset(12, 0),
            builder: (context, controller, child) {
              return GestureDetector(
                onSecondaryTapDown: (details) => controller.open(position: Offset(details.globalPosition.dx, 24)),
                onLongPress: () => controller.open(position: Offset(64, 24)),
                child: ListTile(
                  dense: true,
                  selected: isSelected,
                  selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
                  selectedColor: colorScheme.onPrimaryContainer,
                  leading: Icon(icon, size: 24),
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: subtitle != null
                      ? Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  )
                      : null,
                  onTap: () => onFolderTap(folder.path),
                )
              );
            },
            menuChildren: buildMenu(
              folder: folder,
              onEdit: (folder) => renameRequest(path: folder.path, alias: folder.alias),
              onEditIcon: (folder) => editIconRequest(path: folder.path, iconId: folder.iconId),
              onUnpin: (folder) => unpinRequest(path: folder.path)
            ),
          );
        },
      )
    );
  }

}