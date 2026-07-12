import 'package:ui/state/omit.dart';
import '../domain/ssh_key_file.dart';

class MySshKeysState {
    final List<SshKeyFile> keys;
    final bool loading;
    final String? selectedKeyPath;
    final String? editionModeKeyPath;

    const MySshKeysState({
        this.keys = const [],
        this.loading = false,
        this.selectedKeyPath = null,
        this.editionModeKeyPath = null
    });

    MySshKeysState copyWith({
        Defaulted<List<SshKeyFile>> keys = const Omit(),
        Defaulted<bool> loading = const Omit(),
        Defaulted<String?> selectedKeyPath = const Omit(),
        Defaulted<String?> editionModeKeyPath = const Omit()
    }) {
        return MySshKeysState(
            keys: keys is Omit ? this.keys : keys as List<SshKeyFile>,
            loading: loading is Omit ? this.loading : loading as bool,
            selectedKeyPath: selectedKeyPath is Omit ? this.selectedKeyPath : selectedKeyPath as String?,
            editionModeKeyPath: editionModeKeyPath is Omit ? this.editionModeKeyPath : editionModeKeyPath as String?
        );
    }
}