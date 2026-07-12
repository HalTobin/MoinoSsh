import 'package:domain/model/text_file.dart';
import 'package:feature_file_explorer/feature/file_content/model/search_result.dart';
import 'package:ui/state/omit.dart';

class FileContentState {
    final bool loading;
    final TextFile? file;

    final bool editMode;
    final bool modified;
    final List<int> editedLines;

    final String filePath;
    final String? errorMessage;

    final double textSize;
    final SearchResult? search;
    final int? currentSearchMatchIndex;

    const FileContentState({
        this.loading = true,
        this.filePath = "",
        this.file = null,

        this.editMode = false,
        this.modified = false,
        this.editedLines = const [],
        this.errorMessage = null,

        this.textSize = 13,
        this.search = null,
        this.currentSearchMatchIndex = null,
    });

    FileContentState copyWith({
        Defaulted<bool> loading = const Omit(),
        Defaulted<String> filePath = const Omit(),
        Defaulted<TextFile?> file = const Omit(),

        Defaulted<bool> editMode = const Omit(),
        Defaulted<bool> modified = const Omit(),
        Defaulted<List<int>> editedLines = const Omit(),
        Defaulted<String?> errorMessage = const Omit(),

        Defaulted<double?> textSize = const Omit(),
        Defaulted<SearchResult?> search = const Omit(),
        Defaulted<int?> currentSearchMatchIndex = const Omit(),
    }) {
        return FileContentState(
            loading: loading is Omit ? this.loading : loading as bool,
            file: file is Omit ? this.file : file as TextFile?,
            filePath: filePath is Omit ? this.filePath : filePath as String,

            editMode: editMode is Omit ? this.editMode : editMode as bool,
            modified: modified is Omit ? this.modified : modified as bool,
            editedLines: editedLines is Omit ? this.editedLines : editedLines as List<int>,
            errorMessage: errorMessage is Omit ? this.errorMessage : errorMessage as String?,

            textSize: textSize is Omit ? this.textSize : textSize as double,
            currentSearchMatchIndex: currentSearchMatchIndex is Omit ? this.currentSearchMatchIndex : currentSearchMatchIndex as int?,
            search: search is Omit ? this.search : search as SearchResult?,
        );
    }
}