import 'package:feature_file_explorer/data/file_entry.dart';

sealed class FileContentEvent {}

class SearchContentEvent extends FileContentEvent {
    final String? search;
    SearchContentEvent({required this.search});
}

class ResetSearch extends FileContentEvent {}

class SelectSearchMatchIndex extends FileContentEvent {
    final int index;
    SelectSearchMatchIndex({required this.index});
}

class UpdateTextSize extends FileContentEvent {
    final double newSize;
    UpdateTextSize({required this.newSize});
}

class ToggleEditMode extends FileContentEvent {}

class ModifyText extends FileContentEvent {
    final String newText;
    ModifyText({required this.newText});
}

class WriteContent extends FileContentEvent {}