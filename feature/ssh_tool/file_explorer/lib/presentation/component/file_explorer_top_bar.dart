import 'package:feature_file_explorer/util/path_helper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FileExplorerTopBar extends StatelessWidget {
  final String currentPath;
  final bool isPinned;
  final bool showHidden;
  final Function() onPin;
  final Function() navigateRoot;
  final Function() navigateUp;
  final Function() toggleHiddenFiles;

  const FileExplorerTopBar({
    super.key,
    required this.currentPath,
    required this.isPinned,
    required this.showHidden,
    required this.onPin,
    required this.navigateRoot,
    required this.navigateUp,
    required this.toggleHiddenFiles,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            icon: Icon(isPinned ? LucideIcons.pinOff : LucideIcons.pin),
            onPressed: PathHelper.canNavigateUp(currentPath)
                ? onPin
                : null,
            tooltip: 'Pin directory',
          ),
          IconButton(
            icon: const Icon(LucideIcons.house),
            onPressed: PathHelper.canNavigateUp(currentPath)
                ? navigateRoot
                : null,
            tooltip: 'Go to root',
          ),
          IconButton(
            icon: const Icon(LucideIcons.arrowUp),
            onPressed: PathHelper.canNavigateUp(currentPath)
                ? navigateUp
                : null,
            tooltip: 'Go up',
            disabledColor: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            firstChild: _HideShowButton(showHidden: true, toggle: toggleHiddenFiles),
            secondChild: _HideShowButton(showHidden: false, toggle: toggleHiddenFiles),
            crossFadeState: showHidden ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ],
      ),
    );
  }
}

class _HideShowButton extends StatelessWidget {
  final bool showHidden;
  final Function() toggle;

  const _HideShowButton({
    super.key,
    required this.showHidden,
    required this.toggle
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: toggle,
      style: IconButton.styleFrom(
        backgroundColor: showHidden ? colorScheme.primary : Colors.transparent,
        shape: const CircleBorder(),
      ),
      icon: Icon(
        showHidden ? LucideIcons.eyeOff : LucideIcons.eye,
        color: showHidden ? colorScheme.onPrimary : null,
      ),
    );
  }

}