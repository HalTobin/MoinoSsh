import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileExplorerTopBar extends StatelessWidget {
  final String currentPath;
  final Function() navigateRoot;
  final Function() navigateUp;
  final Function() toggleHiddenFiles;

  const FileExplorerTopBar({
    super.key,
    required this.currentPath,
    required this.navigateRoot,
    required this.navigateUp,
    required this.toggleHiddenFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: navigateRoot,
            tooltip: 'Go to root',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: navigateUp,
            tooltip: 'Go up',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentPath,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.visibility_outlined),
            onPressed: toggleHiddenFiles,
            tooltip: 'Toggle hidden files',
          ),
        ],
      ),
    );
  }
}