import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/sale_line_number.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String content;
  final String? searchQuery;
  final int? focusedLineIndex;
  final double textSize;

  static const double lineHeight = 24.0;

  const HighlightedText({
    super.key,
    required this.content,
    required this.searchQuery,
    required this.focusedLineIndex,
    required this.textSize
  });

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final regex = searchQuery != null
        ? RegExp(RegExp.escape(searchQuery!), caseSensitive: false)
        : null;

    return SelectionArea(
      child: ListView.builder(
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final isFocused = focusedLineIndex == index;

          return _LineItem(
            index: index,
            lineText: lines[index],
            searchQuery: searchQuery,
            isFocused: isFocused,
            textSize: textSize,
            regex: regex,
          );
        },
      )
    );
  }
}

class _LineItem extends StatefulWidget {
  final int index;
  final String lineText;
  final String? searchQuery;
  final bool isFocused;
  final double textSize;
  final RegExp? regex;

  const _LineItem({
    required this.index,
    required this.lineText,
    required this.searchQuery,
    required this.isFocused,
    required this.textSize,
    required this.regex
  });

  @override
  State<_LineItem> createState() => _LineItemState();
}

class _LineItemState extends State<_LineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: Container(
        color: _isHovered
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SaleLineNumber(
              index: widget.index + 1,
              highlight: false,
              textSize: widget.textSize
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
                child: _buildRichTextLine(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichTextLine({
    required BuildContext context
  }) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: widget.textSize,
      height: 1.5,
      fontFeatures: [ FontFeature.tabularFigures() ],
    );

    if (widget.regex == null) {
      return Text(widget.lineText, style: textStyle);
    }
    final matches = widget.regex!.allMatches(widget.lineText);
    if (matches.isEmpty) {
      return Text(widget.lineText, style: textStyle);
    }

    final highlightBg = widget.isFocused
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.primaryContainer;

    final highlightText = widget.isFocused
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onPrimaryContainer;

    int currentIndex = 0;
    final List<TextSpan> spans = [];

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: widget.lineText.substring(currentIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: widget.lineText.substring(match.start, match.end),
          style: TextStyle(
            backgroundColor: highlightBg,
            color: highlightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < widget.lineText.length) {
      spans.add(TextSpan(text: widget.lineText.substring(currentIndex)));
    }

    return RichText(
      text: TextSpan(
        style: textStyle?.copyWith(height: 1.5),
        children: spans,
      ),
    );
  }

}