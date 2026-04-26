import 'package:ui/state/omit.dart';

class FileContentState {
    final bool loading;
    final String fileName;
    final String filePath;
    final String? content;
    final String? searchQuery;
    final String? errorMessage;

    const FileContentState({
        this.loading = true,
        this.fileName = "",
        this.filePath = "",
        this.content = null,
        this.searchQuery = null,
        this.errorMessage = null
    });

    FileContentState copyWith({
        Defaulted<bool> loading = const Omit(),
        Defaulted<String> fileName = const Omit(),
        Defaulted<String> filePath = const Omit(),
        Defaulted<String?> content = const Omit(),
        Defaulted<String?> searchQuery = const Omit(),
        Defaulted<String?> errorMessage = const Omit()
    }) {
        return FileContentState(
            loading: loading is Omit ? this.loading : loading as bool,
            fileName: fileName is Omit ? this.fileName : fileName as String,
            filePath: filePath is Omit ? this.filePath : filePath as String,
            content: content is Omit ? this.content : content as String?,
            searchQuery: searchQuery is Omit ? this.searchQuery : searchQuery as String?,
            errorMessage: errorMessage is Omit ? this.errorMessage : errorMessage as String?
        );
    }
}