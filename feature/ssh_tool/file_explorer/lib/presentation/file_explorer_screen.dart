import 'dart:async';
import 'dart:io' show FileSystemEntity;

import 'package:domain/model/preferences/file_view_mode.dart';
import 'package:feature_file_explorer/data/file_type.dart';
import 'package:feature_file_explorer/feature/file_content/di/file_content_provider.dart';
import 'package:feature_file_explorer/feature/image_viewer/di/image_viewer_provider.dart';
import 'package:feature_file_explorer/presentation/component/file_details_modal.dart';
import 'package:feature_file_explorer/presentation/component/file_fab.dart';
import 'package:feature_file_explorer/presentation/component/folder_warning.dart';
import 'package:feature_file_explorer/presentation/component/new_element_name_dialog.dart';
import 'package:feature_file_explorer/presentation/component/pinned_folder/pinned_folders_menu.dart';
import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:feature_file_explorer/util/path_helper.dart';
import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:ui/navigation/auto_modal.dart';

import '../data/file_entry.dart';
import 'component/file_entry_item.dart';
import 'component/file_explorer_top_bar.dart';
import 'component/permission_denied_dialog.dart';
import 'file_explorer_state.dart';
import 'file_explorer_view_model.dart';

class FileExplorerScreen extends StatefulWidget {
  final FileExplorerState state;
  final bool isNarrow;
  final Function(FileExplorerEvent event) onEvent;
  final Stream<FileExplorerUiEvent> uiEvent;

  const FileExplorerScreen({
    super.key,
    required this.state,
    required this.isNarrow,
    required this.onEvent,
    required this.uiEvent
  });

  @override
  State<StatefulWidget> createState() => FileExplorerScreenState();
}

class FileExplorerScreenState extends State<FileExplorerScreen> {
  bool _draggingFiles = false;

  @override void initState() {
    super.initState();
    widget.uiEvent.listen((event) {
      switch (event) {
        case PermissionDenied():
          _showPermissionDeniedWarningDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleFiles = widget.state.files.where((f) {
      return widget.state.showHidden || !f.isHidden;
    }).toList();

    return PopScope(
      canPop: !PathHelper.canNavigateUp(widget.state.currentPath),
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        else {
          widget.onEvent(NavigateUpEvent());
        }
      },
      child: Scaffold(
        floatingActionButton: FileFab(
          onAction: (action) => _handleFabAction(context, action),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  FileExplorerTopBar(
                    currentPath: widget.state.currentPath,
                    pinnedFolders: widget.state.pinnedFolders,
                    isPinned: widget.state.isPinned,
                    showHidden: widget.state.showHidden,
                    viewMode: widget.state.viewMode,
                    onPin: () => widget.onEvent(PinUnpinEvent()),
                    navigateRoot: () => widget.onEvent(NavigateRootEvent()),
                    navigateUp: () => widget.onEvent(NavigateUpEvent()),
                    navigateTo: (path) => widget.onEvent(OpenFolder(folderPath: path)),
                    toggleHiddenFiles: () => widget.onEvent(ToggleHiddenEvent()),
                    selectViewMode: (viewMode) => widget.onEvent(SelectViewMode(viewMode: viewMode)),
                    onUnpin: (path) => widget.onEvent(OpenFolder(folderPath: path)),
                    onFolderRename: (path, newAlias) => widget.onEvent(RenamePinnedFolder(path: path, newAlias: newAlias)),
                    onEditFolderIcon: (path, newIcon) => widget.onEvent(EditPinnedFolderIcon(path: path, newIcon: newIcon)),
                    onRefresh: () => widget.onEvent(RefreshContent()),
                  ),
                  Expanded(
                    child: DropRegion(
                      formats: const [Formats.fileUri],
                      hitTestBehavior: HitTestBehavior.opaque,
                      onDropOver: _onDropOver,
                      onDropEnter: (_) => setState(() => _draggingFiles = true),
                      onDropLeave: (_) => setState(() => _draggingFiles = false),
                      onPerformDrop: _onPerformDrop,
                      child: Stack(
                        children: [
                          _buildBody(
                            context: context,
                            constraints: constraints,
                            visibleFiles: visibleFiles,
                          ),
                          if (_draggingFiles) _buildDropOverlay(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );

  }

  Widget _buildDropOverlay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            border: Border.all(color: colorScheme.primary, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Icon(
                  LucideIcons.upload,
                  size: 48,
                  color: colorScheme.primary,
                ),
                Text(
                  'Drop to upload',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropOperation _onDropOver(DropOverEvent event) {
    final hasFileUri = event.session.items.any(
      (item) => item.canProvide(Formats.fileUri),
    );
    if (!hasFileUri) {
      return DropOperation.none;
    }
    if (event.session.allowedOperations.contains(DropOperation.copy)) {
      return DropOperation.copy;
    }
    return event.session.allowedOperations.firstOrNull ?? DropOperation.none;
  }

  Future<void> _onPerformDrop(PerformDropEvent event) async {
    final pathFutures = <Future<String?>>[];

    for (final item in event.session.items) {
      final reader = item.dataReader;
      if (reader == null || !reader.canProvide(Formats.fileUri)) {
        continue;
      }

      final completer = Completer<String?>();
      pathFutures.add(completer.future);

      reader.getValue<Uri>(
        Formats.fileUri,
        (uri) {
          if (completer.isCompleted) {
            return;
          }
          if (uri == null) {
            completer.complete(null);
            return;
          }

          try {
            final path = uri.toFilePath();
            if (path.isNotEmpty && FileSystemEntity.isFileSync(path)) {
              completer.complete(path);
            } else {
              completer.complete(null);
            }
          } catch (error) {
            if (kDebugMode) {
              print('Skipping dropped uri "$uri": $error');
            }
            completer.complete(null);
          }
        },
        onError: (error) {
          if (kDebugMode) {
            print('Error reading dropped file uri: $error');
          }
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      );
    }

    final filePaths = (await Future.wait(pathFutures))
        .whereType<String>()
        .toList(growable: false);

    if (!mounted) {
      return;
    }

    if (filePaths.isEmpty) {
      if (kDebugMode) {
        print('Drop ignored: no files to upload.');
      }
      return;
    }

    widget.onEvent(
      UploadFile.multiple(
        localeFilePaths: filePaths,
        remoteTargetPath: widget.state.currentPath,
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
                onOpen: () => _openFile(file),
                openDetails: file is File
                  ? () => _showFileDetails(context: context, constraints: constraints, file: file)
                  : null,
                onDownload: (localeTarget) => widget.onEvent(DownloadFile(remoteFilePath: file.path, localeTargetPath: localeTarget)),
                onDelete: () => widget.onEvent(DeleteFile(filePath: file.path)),
                onRename: (newName) => widget.onEvent(RenameFile(filePath: file.path, newName: newName))
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
          onOpen: () => _openFile(file),
          openDetails: file is File
            ? () => _showFileDetails(context: context, constraints: constraints, file: file)
            : null,
          onClick: () => _onItemTap(context: context, constraints: constraints, file: file),
          onDownload: (localeTarget) => widget.onEvent(DownloadFile(remoteFilePath: file.path, localeTargetPath: localeTarget)),
          onDelete: () => widget.onEvent(DeleteFile(filePath: file.path)),
          onRename: (newName) => widget.onEvent(RenameFile(filePath: file.path, newName: newName))
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

    if (widget.state.loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (widget.state.error.isNotEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.circleAlert, color: Theme.of(context).colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(widget.state.error, style: TextStyle(color: Theme.of(context).colorScheme.error), textAlign: TextAlign.center),
          ],
        ),
      );
    } else if (widget.state.fileListError.isNotEmpty) {
      content = FolderWarning(
        icon: LucideIcons.folderX200,
        text: "Can't open this directory!\n${widget.state.fileListError}",
        color: Theme.of(context).colorScheme.error
      );
    } else if (visibleFiles.isEmpty) {
      content = FolderWarning(
        icon: LucideIcons.folderOpen200,
        text: 'This directory is empty.',
        color: Colors.grey
      );
    } else {
      content = switch (widget.state.viewMode) {
        FileViewMode.grid => _buildGrid(context: context, constraints: constraints, files: visibleFiles),
        FileViewMode.list => _buildList(context: context, constraints: constraints, files: visibleFiles),
      };
    }

    if (!widget.isNarrow) {
      return Row(
        children: [
          SizedBox(
            width: 250,
            child: PinnedFoldersMenu(
              currentPath: widget.state.currentPath,
              folders: widget.state.pinnedFolders,
              onFolderTap: (path) => widget.onEvent(OpenFolder(folderPath: path)),
              onUnpin: (path) => widget.onEvent(PinUnpinEvent(path: path)),
              onFolderRename: (path, alias) => widget.onEvent(RenamePinnedFolder(path: path, newAlias: alias)),
              onIconEdit: (path, icon) => widget.onEvent(EditPinnedFolderIcon(path: path, newIcon: icon)),
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
        widget.onEvent(OpenFolder(folderPath: file.path));
      case File():
        _showFileDetails(context: context, constraints: constraints, file: file);
    }
  }

  void _showFileDetails({
    required BuildContext context,
    required BoxConstraints constraints,
    required File file
  }) {
    final isImage = file.type == FileType.image;

    autoModal(
      context: context,
      constraints: constraints,
      child: FileDetailsModal(
        file: file,
        onDismiss: () => Navigator.pop(context),
        openLabel: isImage ? "Open image" : "Open as text",
        openIcon: isImage ? LucideIcons.fileImage : LucideIcons.fileText,
        openFile: () {
          Navigator.pop(context);
          _navigateToFile(file);
        },
      )
    );
  }

  void _openFile(FileEntry file) {
    switch (file) {
      case Folder():
        widget.onEvent(OpenFolder(folderPath: file.path));
      case File():
        if (!file.openable) return;
        _navigateToFile(file);
    }
  }

  void _navigateToFile(File file) {
    final Widget destination = switch (file.type) {
      FileType.image => ImageViewerProvider(filePath: file.path),
      _ => FileContentProvider(filePath: file.path),
    };

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  void _showPermissionDeniedWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PermissionDeniedDialog(onDismiss: () => Navigator.pop(context));
      }
    );
  }

  Future<void> _handleFabAction(BuildContext context, FileFabAction action) async {
    switch (action) {
      case FileFabAction.newFile:
        showDialog(
          context: context,
          builder: (context) {
            return NewElementNameDialog(
              type: ElementType.file,
              onCreate: (fileName) {
                widget.onEvent(CreateFile(fileName: fileName));
                Navigator.of(context).pop();
              },
              onDismiss: () => Navigator.of(context).pop()
            );
          }
        );
      case FileFabAction.newFolder:
        showDialog(
          context: context,
          builder: (context) {
            return NewElementNameDialog(
              type: ElementType.folder,
              onCreate: (fileName) {
                widget.onEvent(CreateFolder(folderName: fileName));
                Navigator.of(context).pop();
              },
              onDismiss: () => Navigator.of(context).pop()
            );
          }
        );
      case FileFabAction.uploadFile:
        try {
          final FilePickerResult? result = await FilePicker.pickFiles(
            allowMultiple: false,
          );

          if (result == null || result.files.single.path == null) {
            if (kDebugMode) print("Upload canceled: No file selected.");
            return;
          }

          final String localFilePath = result.files.single.path!;
          widget.onEvent(
            UploadFile(
              localeFilePath: localFilePath,
              remoteTargetPath: widget.state.currentPath,
            ),
          );
        } catch (e) {
          if (kDebugMode) print("Error picking file for upload: $e");
        }
        break;
    }
  }

}