import 'package:ui/state/omit.dart';

import '../model/authorized_key_entry.dart';

class SshKeyManagerState {
    final bool remoteLoading;
    final bool applying;
    final String error;
    final String? authorizedKeysPath;
    final List<AuthorizedKeyEntry> remoteKeys;
    final List<String> stagedPublicKeyLines;

    /// True while [remoteKeys] reflects a file that was actually read from the
    /// remote. Writing the file back is only safe in that case, otherwise an
    /// unreadable file would be replaced by whatever the screen happens to show.
    final bool snapshotLoaded;

    const SshKeyManagerState({
        this.remoteLoading = false,
        this.applying = false,
        this.error = '',
        this.authorizedKeysPath,
        this.remoteKeys = const [],
        this.stagedPublicKeyLines = const [],
        this.snapshotLoaded = false,
    });

    bool get canApplyRemoteChanges =>
        snapshotLoaded && authorizedKeysPath != null && !applying && !remoteLoading;

    bool get loadFailed => !snapshotLoaded && !remoteLoading;

    bool get hasPendingRemoteChanges =>
        remoteKeys.any((entry) => entry.markedForDeletion) ||
        stagedPublicKeyLines.isNotEmpty;

    int get pendingChangeCount =>
        remoteKeys.where((entry) => entry.markedForDeletion).length +
        stagedPublicKeyLines.length;

    SshKeyManagerState copyWith({
        Defaulted<bool>? remoteLoading = const Omit(),
        Defaulted<bool>? applying = const Omit(),
        Defaulted<String>? error = const Omit(),
        Defaulted<String?>? authorizedKeysPath = const Omit(),
        Defaulted<List<AuthorizedKeyEntry>>? remoteKeys = const Omit(),
        Defaulted<List<String>>? stagedPublicKeyLines = const Omit(),
        Defaulted<bool>? snapshotLoaded = const Omit(),
    }) {
        return SshKeyManagerState(
            remoteLoading: remoteLoading is Omit ? this.remoteLoading : remoteLoading as bool,
            applying: applying is Omit ? this.applying : applying as bool,
            error: error is Omit ? this.error : error as String,
            authorizedKeysPath: authorizedKeysPath is Omit ? this.authorizedKeysPath : authorizedKeysPath as String?,
            remoteKeys: remoteKeys is Omit ? this.remoteKeys : remoteKeys as List<AuthorizedKeyEntry>,
            stagedPublicKeyLines: stagedPublicKeyLines is Omit ? this.stagedPublicKeyLines : stagedPublicKeyLines as List<String>,
            snapshotLoaded: snapshotLoaded is Omit ? this.snapshotLoaded : snapshotLoaded as bool,
        );
    }
}
