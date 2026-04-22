import 'package:domain/model/ssh/pinned_folder.dart';
import 'package:feature_file_explorer/presentation/component/pinned_folders_menu.dart';
import 'package:feature_file_explorer/util/path_helper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/title_header.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

class FileExplorerTopBar extends StatelessWidget {
  final String currentPath;
  final List<PinnedFolder> pinnedFolders;
  final bool isPinned;
  final bool showHidden;
  final Function() onPin;
  final Function() navigateRoot;
  final Function() navigateUp;
  final Function(String) navigateTo;
  final Function() toggleHiddenFiles;
  final Function(String) onUnpin;
  final Function(String, String) onFolderRename;

  const FileExplorerTopBar({
    super.key,
    required this.currentPath,
    required this.pinnedFolders,
    required this.isPinned,
    required this.showHidden,
    required this.onPin,
    required this.navigateRoot,
    required this.navigateUp,
    required this.navigateTo,
    required this.toggleHiddenFiles,
    required this.onUnpin,
    required this.onFolderRename
  });
  
  Widget _buildPathBar(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => _showCompletePath(context),
        borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _leadingActions({
    required BuildContext context,
    required bool isNarrow
  }) {
    return Row(
      spacing: 4,
      children: [
        if (isNarrow && pinnedFolders.isNotEmpty)
          _TopBarButton(
            icon: LucideIcons.folders,
            onTap: () => _showMyFolders(context)
          ),
        _TopBarButton(
          on: isPinned,
          icon: LucideIcons.pinOff,
          offIcon: LucideIcons.pin,
          onTap: PathHelper.canNavigateUp(currentPath) ? onPin : null
        ),
        _TopBarButton(
          icon: LucideIcons.house,
          onTap: PathHelper.canNavigateUp(currentPath) ? navigateRoot : null,
        ),
        _TopBarButton(
          icon: LucideIcons.arrowUp,
          onTap: PathHelper.canNavigateUp(currentPath) ? navigateUp : null,
        ),
      ],
    );
  }

  Widget _trailingActions() {
    return Row(
      spacing: 4,
      children: [
        _TopBarButton(
          on: showHidden,
          icon: LucideIcons.eye,
          offIcon: LucideIcons.eyeOff,
          onTap: toggleHiddenFiles
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = ScreenFormatHelper.isNarrow(constraints);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: isNarrow
            ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [_buildPathBar(context)]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _leadingActions(context: context, isNarrow: isNarrow),
                    const Spacer(),
                    _trailingActions()
                  ],
                ),
              ],
            )
            : Row(
              children: [
                _leadingActions(context: context, isNarrow: isNarrow),
                const SizedBox(width: 8),
                _buildPathBar(context),
                const SizedBox(width: 8),
                _trailingActions()
              ],
            ),
        );
      }
    );
  }

  void _showCompletePath(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              TitleHeader(
                icon: LucideIcons.folderOpen,
                title: "Current path",
                trailingContent: TitleHeaderTrailingContent.dismissable(
                  onDismiss: () => Navigator.of(context).pop()
                ),
              ),
              Text(currentPath)
            ],
          ),
        );
      }
    );
  }

  void _showMyFolders(BuildContext context) {
    final padding = 16.0;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.directional(top: padding, bottom: 0, start: padding, end: padding/2),
              child: TitleHeader(
                icon: LucideIcons.folders,
                title: "Pinned folders",
                trailingContent: TitleHeaderTrailingContent.dismissable(
                  onDismiss: () => Navigator.of(context).pop()
                ),
              )
            ),
            PinnedFoldersMenu(
              currentPath: currentPath,
              folders: pinnedFolders,
              onFolderTap: (folder) {
                Navigator.of(context).pop();
                navigateTo(folder);
              },
              onUnpin: onUnpin,
              onFolderRename: onFolderRename,
            ),
            SizedBox(
              height: 12,
            )
          ],
        );
      }
    );
  }

}

class _TopBarButton extends StatelessWidget {
  final bool on;
  final IconData icon;
  final IconData? offIcon;
  final Function()? onTap;

  const _TopBarButton({
    super.key,
    this.on = false,
    required this.icon,
    this.offIcon = null,
    required this.onTap
  });

  Widget button({
    required BuildContext context,
    required bool isOn
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onTap,
      iconSize: 22.0,
      disabledColor: Colors.grey.withValues(alpha: 0.6),
      style: IconButton.styleFrom(
        backgroundColor: isOn ? colorScheme.primary : Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        minimumSize: const Size(32, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: Icon(
        isOn ? icon : (offIcon ?? icon),
        color: isOn ? colorScheme.onPrimary : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 150),
      firstChild: button(context: context, isOn: true),
      secondChild: button(context: context, isOn: false),
      crossFadeState: on ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

}
