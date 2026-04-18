import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

import '../../util/size_helper.dart';

class FileEntryItem extends StatelessWidget {
  final FileEntry file;
  final Function() onClick;

  const FileEntryItem({
    super.key,
    required this.file,
    required this.onClick
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

    return ListTile(
      onTap: onClick,
      tileColor: file.isHidden ? Colors.grey.withValues(alpha: 0.05) : null,
      leading: Icon(
        iconData,
        color: file.isHidden
            ? Colors.grey
            : (isFolder ? Colors.blueAccent : Theme.of(context).iconTheme.color),
        size: 32,
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
    );
  }

}