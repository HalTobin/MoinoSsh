import 'dart:async';

import 'package:feature_file_explorer/feature/file_content/presentation/file_content_event.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/determine_edited_lines_use_case.dart';
import 'package:feature_file_explorer/feature/file_content/use_case/file_content_use_cases.dart';
import 'package:flutter/foundation.dart';

import 'component/text_content/content_text_value.dart';
import 'file_content_state.dart';

class FileContentViewModel extends ChangeNotifier {
    final String filePath;

    FileContentViewModel({
        required FileContentUseCases fileContentUseCase,
        required this.filePath
    })
      : _useCases = fileContentUseCase
    {
        if (kDebugMode) {
            print("[$_tag] init()");
        }
        _init();
    }

    final FileContentUseCases _useCases;

    FileContentState _state = FileContentState();
    FileContentState get state => _state;

    final StreamController<FileContentUiEvent> _uiEventController = StreamController<FileContentUiEvent>.broadcast();
    Stream<FileContentUiEvent> get uiEvent => _uiEventController.stream;

    String? _edition;

    Future<void> _init() async {
        _loadFile(filePath);
    }

    Future<void> _loadFile(String path) async {
        final file = await _useCases.getFileUseCase.execute(path);
        _state = _state.copyWith(file: file, filePath: path);
        notifyListeners();
    }

    Future<void> onEvent(FileContentEvent event) async {
        switch (event) {
            case SearchContentEvent():
                _searchContent(event.search);
            case ResetSearch():
                _resetSearch();
            case SelectSearchMatchIndex():
                _selectSearchMatchIndex(event.index);
            case UpdateTextSize():
                _updateTextSize(event.newSize);
            case ToggleEditMode():
                _toggleEditMode();
            case ModifyText():
                _modifyText(event.newText);
            case WriteContent():
                _writeContent();
        }
    }

    void _searchContent(String? search) async {
        final content = _state.file?.content ?? "";
        final searchResult = _useCases.searchInFileContentUseCase.execute(search: search ?? "", content: content);

        _state = _state.copyWith(search: searchResult, currentSearchMatchIndex: 0);

        if (searchResult.linesWithMatch.isNotEmpty) {
            _selectSearchMatchIndex(0);
        }

        notifyListeners();
    }

    void _resetSearch() {
        _state = _state.copyWith(search: null, currentSearchMatchIndex: null);
        notifyListeners();
    }

    Future<void> _selectSearchMatchIndex(int index) async {
        final matches = _state.search?.linesWithMatch ?? [];
        if (index >= 0 && index < matches.length) {
            _state = _state.copyWith(currentSearchMatchIndex: index);
            _uiEventController.add(FocusMatchEvent(matches[index]));
            notifyListeners();
        }
    }

    void _updateTextSize(double newSize) {
        if (newSize >= ContentTextValue.minTextSize && newSize <= ContentTextValue.maxTextSize) {
            _state = _state.copyWith(textSize: newSize);
            notifyListeners();
        }
    }

    void _toggleEditMode() {
        _state = _state.copyWith(editMode: !_state.editMode, modified: false);
        notifyListeners();
    }

    Future<void> _modifyText(String newText) async {
        _edition = newText;
        final modified = newText != _state.file?.content;

        final texts = TextComparison(original: _state.file?.content ?? "", edited: newText);
        final List<int> editedLines = modified
            ? await compute(_useCases.determineEditedLinesUseCase.execute, texts)
            : <int>[];

        _state = _state.copyWith(modified: modified, editedLines: editedLines);
        notifyListeners();
    }

    Future<void> _writeContent() async {
        _state = _state.copyWith(loading: true);
        notifyListeners();
        if (_edition != null) {
            final result = await _useCases.writeFileContentUseCase.execute(_state.filePath, _edition!);
            if (result) {
                await _loadFile(filePath);
                await _modifyText(_state.file?.content ?? "");
            }
        }
        _state = _state.copyWith(loading: false);
        notifyListeners();
    }

    static final String _tag = "FileContentViewModel";

}

sealed class FileContentUiEvent {}

class FocusMatchEvent extends FileContentUiEvent {
    final int matchingLine;
    FocusMatchEvent(this.matchingLine);
}