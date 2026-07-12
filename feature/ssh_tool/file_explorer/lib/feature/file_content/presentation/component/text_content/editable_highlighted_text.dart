import 'dart:async';

import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/sale_line_number.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/search_highlight_controller.dart';
import 'package:flutter/material.dart';

class EditableHighlightedText extends StatefulWidget {
  final String initialContent;
  final String? searchQuery;
  final double textSize;
  final int? focusedLineIndex;
  final List<int> editedLines;
  final Function(String newText) onContentChanged;

  const EditableHighlightedText({
    super.key,
    required this.initialContent,
    required this.searchQuery,
    required this.textSize,
    required this.focusedLineIndex,
    required this.editedLines,
    required this.onContentChanged
  });

  @override
  State<EditableHighlightedText> createState() => _EditableHighlightedTextState();
}

class _EditableHighlightedTextState extends State<EditableHighlightedText> {
  late SearchHighlightController _controller;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _lineScrollController = ScrollController();
  int _lineCount = 1;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = SearchHighlightController(
      text: widget.initialContent,
      searchQuery: widget.searchQuery,
      focusedLineIndex: widget.focusedLineIndex
    );

    _lineCount = '\n'.allMatches(widget.initialContent).length + 1;

    _scrollController.addListener(() {
      if (_lineScrollController.hasClients) {
        _lineScrollController.jumpTo(_scrollController.offset);
      }
    });

    _controller.addListener(() {
      final currentText = _controller.text;
      final newLineCount = '\n'.allMatches(currentText).length + 1;
      if (newLineCount != _lineCount) {
        setState(() {
          _lineCount = newLineCount;
        });
      }

      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onContentChanged.call(currentText);
      });
    });
  }

  @override
  void didUpdateWidget(covariant EditableHighlightedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _controller.updateSearchQuery(widget.searchQuery, widget.focusedLineIndex);
    }
    if (oldWidget.focusedLineIndex != widget.focusedLineIndex) {
      _controller.updateFocusedLineIndex(widget.focusedLineIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: widget.textSize,
      height: 1.5,
      fontFeatures: [const FontFeature.tabularFigures()],
    );
    final strutStyle = StrutStyle(
      fontSize: widget.textSize,
      height: 1.5,
      forceStrutHeight: true,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          controller: _lineScrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_lineCount, (index) {
                return SaleLineNumber(
                  index: index + 1,
                  highlight: widget.editedLines.contains(index),
                  textSize: widget.textSize,
                  padding: const EdgeInsets.only(right: 4.0),
                );
              }),
            ),
          ),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: IntrinsicWidth(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme()
                      ),
                      child: TextField(
                        controller: _controller,
                        scrollController: _scrollController,
                        maxLines: null,
                        style: textStyle,
                        strutStyle: strutStyle,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 8, top: 4, bottom: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  )
                )
              );
            }
          )
        ),
      ],
    );
  }

}