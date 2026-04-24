import 'package:ui/state/omit.dart';

class FileContentState {
    final bool loading;
    final String? content;

    const FileContentState({
        this.loading = true,
        this.content = null
    });

    FileContentState copyWith({
        Defaulted<bool> loading = const Omit(),
        Defaulted<String?> content = const Omit()
    }) {
        return FileContentState(
            loading: loading is Omit ? this.loading : loading as bool,
            content: content is Omit ? this.content : content as String?
        );
    }
}