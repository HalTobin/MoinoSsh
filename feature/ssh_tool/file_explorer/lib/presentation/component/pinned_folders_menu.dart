import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:feature_file_explorer/presentation/component/rename_dialog.dart';
import 'package:flutter/material.dart';

class PinnedFoldersMenu extends StatelessWidget {
  final String? currentPath;
  final List<PinnedFolder> folders;
  final Function(String) onFolderTap;
  final Function(String) onUnpin;
  final Function(String, String) onFolderRename;

  const PinnedFoldersMenu({
    super.key,
    required this.currentPath,
    required this.folders,
    required this.onFolderTap,
    required this.onUnpin,
    required this.onFolderRename
  });

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
            onDismiss: () => Navigator.of(context).pop,
            onUnpin: () {
              onUnpin(path);
              Navigator.of(context).pop();
            },
            onRename: (newAlias) {
              onFolderRename(path, newAlias);
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

          return GestureDetector(
            onSecondaryTap: () => renameRequest(path: folder.path, alias: folder.alias),
            onLongPress: () => renameRequest(path: folder.path, alias: folder.alias),
            child: ListTile(
              dense: true,
              selected: isSelected,
              selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.6),
              selectedColor: colorScheme.onPrimaryContainer,
              leading: const Icon(Icons.folder_outlined, size: 20),
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
            ),
          );
        },
      )
    );
  }

}