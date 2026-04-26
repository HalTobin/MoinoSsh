import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String content;
  final String? searchQuery;

  const HighlightedText({
    super.key,
    required this.content,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return Text(content);
    }

    final regex = RegExp(searchQuery!, caseSensitive: false);
    final matches = regex.allMatches(content);

    if (matches.isEmpty) {
      return Text(content);
    }

    int currentIndex = 0;
    final List<TextSpan> spans = [];

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: content.substring(currentIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: content.substring(match.start, match.end),
          style: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < content.length) {
      spans.add(TextSpan(text: content.substring(currentIndex)));
    }

    return RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: spans));
  }
}