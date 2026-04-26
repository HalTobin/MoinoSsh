import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:feature_file_explorer/presentation/component/file_details_modal.dart';
import 'package:feature_file_explorer/presentation/component/folder_warning.dart';
import 'package:feature_file_explorer/presentation/component/pinned_folder/pinned_folders_menu.dart';
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';

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
                  child: _buildBody(context: context, constraints: constraints, visibleFiles: visibleFiles),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildGrid({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<FileEntry> files
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: files.length,
      itemBuilder: (gridContext, index) {
        final file = files[index];
        return Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: InkWell(
            onTap: () => _onItemTap(context: context, constraints: constraints, file: file),
            child: Center(
              child: FileEntryItem(
                file: file,
                onClick: null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildList({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<FileEntry> files
  }) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (listContent, index) {
        final file = files[index];
        return FileEntryItem(
          file: file,
          onClick: () => _onItemTap(context: context, constraints: constraints, file: file),
        );
      },
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required BoxConstraints constraints,
    required List<FileEntry> visibleFiles
  }) {
    Widget content;

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
    } else if (state.fileListError.isNotEmpty) {
      content = FolderWarning(
        icon: LucideIcons.folderX200,
        text: "Can't open this directory!\n${state.fileListError}",
        color: Theme.of(context).colorScheme.error
      );
    } else if (visibleFiles.isEmpty) {
      content = FolderWarning(
        icon: LucideIcons.folderOpen200,
        text: 'This directory is empty.',
        color: Colors.grey
      );
    } else {
      content = switch (state.viewMode) {
        FileViewMode.grid => _buildGrid(context: context, constraints: constraints, files: visibleFiles),
        FileViewMode.list => _buildList(context: context, constraints: constraints, files: visibleFiles),
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

  void _onItemTap({
    required BuildContext context,
    required BoxConstraints constraints,
    required FileEntry file
  }) {
    switch (file) {
      case Folder():
        onEvent(OpenFolder(folderPath: file.path));
      case File():
        autoModal(
          context: context,
          constraints: constraints,
          child: FileDetailsModal(
            file: file,
            onDismiss: () => Navigator.pop(context)
          )
        );
    }
  }

}