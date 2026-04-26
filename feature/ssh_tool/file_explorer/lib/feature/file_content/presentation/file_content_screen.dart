import 'package:feature_file_explorer/feature/file_content/presentation/component/file_content_tools.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_filter_field.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_search_field.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_event.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'component/file_content_title.dart';
import 'component/highlighted_text.dart';

class FileContentScreen extends StatelessWidget {
  final FileContentState state;
  final Function(FileContentEvent) onEvent;

  const FileContentScreen({
    super.key,
    required this.state,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: FileContentTitle(fileName: state.fileName, filePath: state.filePath)
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final errorMessage = state.errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              "Failed to load file",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(errorMessage),
          ],
        ),
      );
    }

    if (state.content == null && state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FileContentTools(onEvent: onEvent),

        Expanded(
          child: SingleChildScrollView(
            child: InteractiveViewer(
              panEnabled: false,
              minScale: 1.0,
              maxScale: 3.0,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HighlightedText(
                    content: state.content!,
                    searchQuery: state.searchQuery,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}