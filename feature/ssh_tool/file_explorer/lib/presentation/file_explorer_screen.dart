import 'package:feature_file_explorer/presentation/file_explorer_event.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            FileExplorerTopBar(
              currentPath: state.currentPath,
              showHidden: state.showHidden,
              navigateRoot: () => onEvent(NavigateRootEvent()),
              navigateUp: () => onEvent(NavigateUpEvent()),
              toggleHiddenFiles: () => onEvent(ToggleHiddenEvent()),
            ),
            Expanded(
              child: _buildBody(visibleFiles),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<FileEntry> visibleFiles) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              state.error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (visibleFiles.isEmpty) {
      return const Center(
        child: Text(
          'This directory is empty.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    if (!isNarrow) {
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
                onClick: () => throw UnimplementedError(),
              ),
            ),
          );
        },
      );
    }

    // List View for narrow screens (Phones)
    return ListView.builder(
      itemCount: visibleFiles.length,
      itemBuilder: (context, index) {
        final file = visibleFiles[index];
        return FileEntryItem(
          file: file,
          onClick: () => throw UnimplementedError(),
        );
      },
    );
  }

}