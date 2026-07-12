import 'dart:async';

import 'package:feature_file_explorer/feature/file_content/presentation/component/edit_icon_button.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/exit_without_saving_dialog.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/file_content_text.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/save_icon_button.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/search_icon_button.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_search_field.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/component/text_size_controller.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_event.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_state.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import 'component/file_content_title.dart';
import 'component/text_content/highlighted_text.dart';

class FileContentScreen extends StatefulWidget {
  final FileContentState state;
  final Function(FileContentEvent) onEvent;
  final Stream<FileContentUiEvent> uiEvent;

  const FileContentScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.uiEvent
  });

  @override
  State<StatefulWidget> createState() => _FileContentScreenState();

}

class _FileContentScreenState extends State<FileContentScreen> {
  late StreamSubscription _uiSubscription;
  final ScrollController _scrollController = ScrollController();
  int? focusedLine;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();

    _uiSubscription = widget.uiEvent.listen((event) {
      switch (event) {
        case FocusMatchEvent():
          _scrollToMatch(event.matchingLine);
      }
    });
  }

  void _scrollToMatch(int matchingLine) {
    if (kDebugMode) {
      print("Scrolling to: $matchingLine");
    }
    focusedLine = matchingLine;
    double targetOffset = matchingLine * HighlightedText.lineHeight;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    final offset = (clampedOffset);
    _scrollController.jumpTo(offset);
  }

  void _toggleSearch() {
    setState(() {
      showSearch = !showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = ScreenFormatHelper.isNarrow(constraints);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(LucideIcons.arrowLeft),
              onPressed: () {
                if (widget.state.modified) {
                  _showExitWithoutSavingDialog();
                }
                else {
                  Navigator.of(context).pop();
                }
              },
            ),
            centerTitle: true,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            title: FileContentTitle(
              fileName: widget.state.file?.name ?? "",
              filePath: widget.state.filePath,
              modified: widget.state.modified,
            ),
            actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            actions: [
              SearchIconButton(
                onToggleSearch: () => _toggleSearch(),
                showSearch: showSearch
              ),
              TextSizeController(
                isNarrow: isNarrow,
                onTextSizeChange: (newSize) => widget.onEvent(UpdateTextSize(newSize: newSize))
              ),

              SizedBox(width: 16),

              if (widget.state.file?.isEditable ?? false)
                EditIconButton(
                  editMode: widget.state.editMode,
                  onPressed: () => widget.onEvent(ToggleEditMode()),
                ),

              SaveIconButton(
                editMode: widget.state.editMode,
                onPressed: () => widget.onEvent(WriteContent()),
              )
            ],
          ),
          body: _buildBody(context),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    final errorMessage = widget.state.errorMessage;
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

    final content = widget.state.file?.content;
    if (content == null && widget.state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (showSearch)
          TextSearchField(
            enterSearch: (search) => widget.onEvent(SearchContentEvent(search: search)),
            resetSearch: () {
              widget.onEvent(ResetSearch());
              _toggleSearch();
            },
            selectedSearchIndex: widget.state.currentSearchMatchIndex,
            selectSearchIndex: (matchIndex) => widget.onEvent(SelectSearchMatchIndex(index: matchIndex)),
            search: widget.state.search
          ),

        Expanded(
          child: FileContentText(
            scrollController: _scrollController,
            editMode: widget.state.editMode,
            content: content ?? "",
            searchQuery: widget.state.search?.keyword,
            focusedLineIndex: focusedLine,
            textSize: widget.state.textSize,
            editedLines: widget.state.editedLines,
            onContentChanged: (newText) => widget.onEvent(ModifyText(newText: newText)),
          ),
        )
      ],
    );
  }

  void _showExitWithoutSavingDialog() {
    final screenNavigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ExitWithoutSavingDialog(
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onExit: () {
            Navigator.of(dialogContext).pop();
            screenNavigator.pop();
          }
        );
      }
    );
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    super.dispose();
  }

}