import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:feature_file_explorer/presentation/component/pinned_folders_menu.dart';
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/file_entry.dart';
import 'component/file_entry_item.dart';
import 'component/file_explorer_top_bar.dart';
import 'file_explorer_state.dart';

class FileExplorerScreen extends StatelessWidget {
  final FileExplorerState state;
  final bool isNarrow;
  final Function(FileExplorerEvent event) onEvent;

  const FileExplorerScreen({
    super.key,
    required this.state,
    required this.isNarrow,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    final visibleFiles = state.files.where((f) {
      return state.showHidden || !f.isHidden;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                FileExplorerTopBar(
                  currentPath: state.currentPath,
                  pinnedFolders: state.pinnedFolders,
                  isPinned: state.isPinned,
                  showHidden: state.showHidden,
                  viewMode: state.viewMode,
                  onPin: () => onEvent(PinUnpinEvent()),
                  navigateRoot: () => onEvent(NavigateRootEvent()),
                  navigateUp: () => onEvent(NavigateUpEvent()),
                  navigateTo: (path) => onEvent(OpenFolder(folderPath: path)),
                  toggleHiddenFiles: () => onEvent(ToggleHiddenEvent()),
                  selectViewMode: (viewMode) => onEvent(SelectViewMode(viewMode: viewMode)),
                  onUnpin: (path) => onEvent(OpenFolder(folderPath: path)),
                  onFolderRename: (path, newAlias) => onEvent(RenamePinnedFolder(path: path, newAlias: newAlias)),
                  onEditFolderIcon: (path, newIcon) => onEvent(EditPinnedFolderIcon(path: path, newIcon: newIcon)),
                ),
                Expanded(
                  child: _buildBody(context, visibleFiles),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<FileEntry> visibleFiles) {
    Widget content;

    Widget buildGrid() {
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          childAspectRatio: 3.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: visibleFiles.length,
        itemBuilder: (context, index) {
          final file = visibleFiles[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            child: Center(
              child: FileEntryItem(
                file: file,
                onClick: () => onEvent(OpenFolder(folderPath: file.path)),
              ),
            ),
          );
        },
      );
    }

    Widget buildList() {
      return ListView.builder(
        itemCount: visibleFiles.length,
        itemBuilder: (context, index) {
          final file = visibleFiles[index];
          return FileEntryItem(
            file: file,
            onClick: () => onEvent(OpenFolder(folderPath: file.path)),
          );
        },
      );
    }

    if (state.loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (state.error.isNotEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.circleAlert, color: Theme.of(context).colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(state.error, style: TextStyle(color: Theme.of(context).colorScheme.error), textAlign: TextAlign.center),
          ],
        ),
      );
    } else if (visibleFiles.isEmpty) {
      content = const Center(
        child: Text('This directory is empty.', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    } else {
      content = switch (state.viewMode) {
        FileViewMode.grid => buildGrid(),
        FileViewMode.list => buildList(),
      };
    }

    if (!isNarrow) {
      return Row(
        children: [
          SizedBox(
            width: 250,
            child: PinnedFoldersMenu(
              currentPath: state.currentPath,
              folders: state.pinnedFolders,
              onFolderTap: (path) => onEvent(OpenFolder(folderPath: path)),
              onUnpin: (path) => onEvent(PinUnpinEvent(path: path)),
              onFolderRename: (path, alias) => onEvent(RenamePinnedFolder(path: path, newAlias: alias)),
              onIconEdit: (path, icon) => onEvent(EditPinnedFolderIcon(path: path, newIcon: icon)),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: content),
        ],
      );
    }

    return content;
  }

}