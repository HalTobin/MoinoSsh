import 'package:ui/state/omit.dart';
import 'package:util/ssh/public_key_line.dart';

import '../model/authorized_keys_file.dart';

class SshKeyManagerState {
    final bool remoteLoading;
    final bool applying;
    final String error;
    final String? authorizedKeysPath;
    final List<String> stagedPublicKeyLines;

    /// The file as it was read from the remote, carrying any pending deletion
    /// marks. Null until a read succeeds, which is what makes writing safe:
    /// an unreadable file can never be replaced by what the screen shows.
    final AuthorizedKeysFile? remoteFile;

    /// Whether the file existed when it was read, and the digest of what was
    /// read. Both are checked again before writing to catch a concurrent change.
    final bool remoteFileExists;
    final String remoteContentHash;

    const SshKeyManagerState({
        this.remoteLoading = false,
        this.applying = false,
        this.error = '',
        this.authorizedKeysPath,
        this.stagedPublicKeyLines = const [],
        this.remoteFile,
        this.remoteFileExists = false,
        this.remoteContentHash = '',
    });

    bool get snapshotLoaded => remoteFile != null;

    bool get canApplyRemoteChanges =>
        snapshotLoaded && authorizedKeysPath != null && !applying && !remoteLoading;

    bool get loadFailed => !snapshotLoaded && !remoteLoading;

    List<AuthorizedKeyEntry> get remoteKeys => remoteFile?.keyEntries ?? const [];

    /// Keys waiting to be added. Staged lines are validated before they get here,
    /// so they always parse.
    List<SshPublicKeyLine> get stagedKeys => stagedPublicKeyLines
        .map(SshPublicKeyLine.tryParse)
        .whereType<SshPublicKeyLine>()
        .toList();

    List<AuthorizedKeyEntry> get keysMarkedForDeletion =>
        remoteFile?.entriesMarkedForDeletion.toList() ?? const [];

    bool get hasPendingRemoteChanges =>
        (remoteFile?.hasDeletions ?? false) || stagedPublicKeyLines.isNotEmpty;

    int get pendingChangeCount =>
        (remoteFile?.deletionCount ?? 0) + stagedPublicKeyLines.length;

    /// True when applying would leave the account with no authorized keys.
    bool get wouldRemoveEveryKey =>
        remoteFile?.wouldRemoveEveryKey(stagedPublicKeyLines) ?? false;

    SshKeyManagerState copyWith({
        Defaulted<bool>? remoteLoading = const Omit(),
        Defaulted<bool>? applying = const Omit(),
        Defaulted<String>? error = const Omit(),
        Defaulted<String?>? authorizedKeysPath = const Omit(),
        Defaulted<List<String>>? stagedPublicKeyLines = const Omit(),
        Defaulted<AuthorizedKeysFile?>? remoteFile = const Omit(),
        Defaulted<bool>? remoteFileExists = const Omit(),
        Defaulted<String>? remoteContentHash = const Omit(),
    }) {
        return SshKeyManagerState(
            remoteLoading: remoteLoading is Omit ? this.remoteLoading : remoteLoading as bool,
            applying: applying is Omit ? this.applying : applying as bool,
            error: error is Omit ? this.error : error as String,
            authorizedKeysPath: authorizedKeysPath is Omit ? this.authorizedKeysPath : authorizedKeysPath as String?,
            stagedPublicKeyLines: stagedPublicKeyLines is Omit ? this.stagedPublicKeyLines : stagedPublicKeyLines as List<String>,
            remoteFile: remoteFile is Omit ? this.remoteFile : remoteFile as AuthorizedKeysFile?,
            remoteFileExists: remoteFileExists is Omit ? this.remoteFileExists : remoteFileExists as bool,
            remoteContentHash: remoteContentHash is Omit ? this.remoteContentHash : remoteContentHash as String,
        );
    }
}
