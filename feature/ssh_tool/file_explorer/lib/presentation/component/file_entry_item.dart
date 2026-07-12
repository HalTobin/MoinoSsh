import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:feature_file_explorer/presentation/component/rename_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

import '../../util/size_helper.dart';
import 'delete_file_dialog.dart';

class FileEntryItem extends StatelessWidget {
  final FileEntry file;
  final Function()? onClick;
  final Function() onOpen;
  final Function()? openDetails;
  final Function(String) onDownload;
  final Function() onDelete;
  final Function(String newName) onRename;

  const FileEntryItem({
    super.key,
    required this.file,
    required this.onClick,
    required this.onOpen,
    required this.openDetails,
    required this.onDownload,
    required this.onDelete,
    required this.onRename
  });

  @override
  Widget build(BuildContext context) {
    final isFolder = file is Folder;
    final IconData iconData = switch (file) {
      Folder() => LucideIcons.folder,
      File(type: var t) => t.icon ?? LucideIcons.file,
    };

    final String? subtitleText = switch (file) {
      Folder() => null,
      File(size: var size) => SizeHelper.formatSize(size),
    };

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
      child: ListTile(
        onTap: onClick,
        tileColor: file.isHidden ? Colors.grey.withValues(alpha: 0.05) : null,
        leading: Icon(
          iconData,
          color: file.isHidden
            ? Colors.grey
            : (isFolder ? Theme.of(context).colorScheme.primary : null),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            color: file.isHidden ? Colors.grey : null,
            fontWeight: isFolder ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitleText != null ? Text(subtitleText) : null,
      ),
    );
  }

  void _showMenu(BuildContext context, Offset tapPosition) {
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    );

    showMenu<_FileAction>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<_FileAction>(
          value: _FileAction.open,
          enabled: file.openable,
          child: Row(
            children: [
              Icon(LucideIcons.eye, size: 18),
              SizedBox(width: 12),
              Text('Open'),
            ],
          ),
        ),
        const PopupMenuItem<_FileAction>(
          value: _FileAction.rename,
          child: Row(
            children: [
              Icon(LucideIcons.pencil, size: 18),
              SizedBox(width: 12),
              Text('Rename'),
            ],
          ),
        ),
        if (file is! Folder)
          const PopupMenuItem<_FileAction>(
            value: _FileAction.details,
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 18),
                SizedBox(width: 12),
                Text('Details'),
              ],
            ),
          ),
        if (file is! Folder)
          const PopupMenuItem<_FileAction>(
            value: _FileAction.download,
            child: Row(
              children: [
                Icon(LucideIcons.download, size: 18),
                SizedBox(width: 12),
                Text('Download'),
              ],
            ),
          ),
        PopupMenuItem<_FileAction>(
          value: _FileAction.delete,
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
        case _FileAction.open:
          onOpen();
        case _FileAction.rename:
          _showRenameDialog(context);
          break;
        case _FileAction.details:
          openDetails?.call();
          break;
        case _FileAction.download:
          _download();
          break;
        case _FileAction.delete:
          _showDeleteDialog(context);
          break;
        case null: break;
      }
    });
  }

  Future<void> _download() async {
    try {
      final String? selectedDirectory = await FilePicker.getDirectoryPath(
        dialogTitle: 'Select download destination',
      );

      if (selectedDirectory == null) {
        if (kDebugMode) print("Download canceled: No directory selected.");
        return;
      }

      onDownload(selectedDirectory);

    } catch (e) {
      if (kDebugMode) print("Error picking directory path: $e");
    }
  }

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return RenameDialog(
          currentAlias: file.name,
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onRename: (String newName) {
            if (newName.trim().isNotEmpty) {
              onRename(newName.trim());
            }
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return DeleteFileDialog(
          file: file,
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onDelete: () {
            onDelete();
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

}

enum _FileAction {
  open(identifier: "open"),
  rename(identifier: "rename"),
  details(identifier: "details"),
  download(identifier: "download"),
  delete(identifier: "delete");

  const _FileAction({
    required this.identifier
  });

  final String identifier;
}