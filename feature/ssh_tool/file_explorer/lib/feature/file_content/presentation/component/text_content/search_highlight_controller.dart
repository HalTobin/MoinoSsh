import 'package:flutter/material.dart';

class SearchHighlightController extends TextEditingController {
  String? searchQuery;
  int? focusedLineIndex;

  SearchHighlightController({
    super.text,
    required this.searchQuery,
    required this.focusedLineIndex
  });

  void updateSearchQuery(String? newQuery, int? newFocusedLineIndex) {
    searchQuery = newQuery;
    focusedLineIndex = newFocusedLineIndex;
    notifyListeners();
  }

  void updateFocusedLineIndex(int? newFocusedLineIndex) {
    focusedLineIndex = newFocusedLineIndex;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = Theme.of(context);
    final String currentText = text;

    if (searchQuery == null || searchQuery!.isEmpty) {
      return TextSpan(text: currentText, style: style);
    }

    final regex = RegExp(RegExp.escape(searchQuery!), caseSensitive: false);
    final matches = regex.allMatches(currentText);

    if (matches.isEmpty) {
      return TextSpan(text: currentText, style: style);
    }

    final primaryBg = theme.colorScheme.primaryContainer;
    final primaryText = theme.colorScheme.onPrimaryContainer;

    final tertiaryBg = theme.colorScheme.tertiaryContainer;
    final tertiaryText = theme.colorScheme.onTertiaryContainer;

    int currentIndex = 0;
    final List<TextSpan> spans = [];

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: currentText.substring(currentIndex, match.start)));
      }

      final int currentLine = '\n'.allMatches(currentText.substring(0, match.start)).length;

      final isFocused = focusedLineIndex == currentLine;
      final highlightBg = isFocused ? tertiaryBg : primaryBg;
      final highlightText = isFocused ? tertiaryText : primaryText;

      spans.add(
        TextSpan(
          text: currentText.substring(match.start, match.end),
          style: style?.copyWith(
            backgroundColor: highlightBg,
            color: highlightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < currentText.length) {
      spans.add(TextSpan(text: currentText.substring(currentIndex)));
    }

    return TextSpan(style: style, children: spans);
  }
}