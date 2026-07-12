import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/editable_highlighted_text.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/highlighted_text.dart';
import 'package:flutter/material.dart';

class FileContentText extends StatelessWidget {
  final bool editMode;
  final String content;
  final String? searchQuery;
  final int? focusedLineIndex;
  final double textSize;
  final ScrollController scrollController;
  final List<int> editedLines;
  final Function(String newText) onContentChanged;

  static const double lineHeight = 24.0;

  const FileContentText({
    super.key,
    required this.editMode,
    required this.content,
    required this.searchQuery,
    required this.focusedLineIndex,
    required this.textSize,
    required this.scrollController,
    required this.editedLines,
    required this.onContentChanged
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _buildText(),
    );
  }

  Widget _buildText() {
    if (!editMode) {
      return HighlightedText(
        content: content,
        searchQuery: searchQuery,
        focusedLineIndex: focusedLineIndex,
        textSize: textSize,
      );
    }
    else {
      return EditableHighlightedText(
        initialContent: content,
        searchQuery: searchQuery,
        textSize: textSize,
        focusedLineIndex: focusedLineIndex,
        editedLines: editedLines,
        onContentChanged: onContentChanged,
      );
    }
  }

}