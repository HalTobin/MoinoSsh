import 'package:ui/state/omit.dart';

import '../model/authorized_key_entry.dart';

class SshKeyManagerState {
    final bool loading;
    final bool applying;
    final String error;
    final int selectedTab;
    final String? authorizedKeysPath;
    final List<AuthorizedKeyEntry> remoteKeys;
    final List<String> stagedPublicKeyLines;
    final List<PendingGeneratedKey> pendingGeneratedKeys;
    final int localKeysRefreshToken;

    const SshKeyManagerState({
        this.loading = true,
        this.applying = false,
        this.error = '',
        this.selectedTab = 0,
        this.authorizedKeysPath,
        this.remoteKeys = const [],
        this.stagedPublicKeyLines = const [],
        this.pendingGeneratedKeys = const [],
        this.localKeysRefreshToken = 0,
    });

    bool get hasPendingRemoteChanges =>
        remoteKeys.any((entry) => entry.markedForDeletion) ||
        stagedPublicKeyLines.isNotEmpty;

    int get pendingChangeCount =>
        remoteKeys.where((entry) => entry.markedForDeletion).length +
        stagedPublicKeyLines.length;

    SshKeyManagerState copyWith({
        Defaulted<bool>? loading = const Omit(),
        Defaulted<bool>? applying = const Omit(),
        Defaulted<String>? error = const Omit(),
        Defaulted<int>? selectedTab = const Omit(),
        Defaulted<String?>? authorizedKeysPath = const Omit(),
        Defaulted<List<AuthorizedKeyEntry>>? remoteKeys = const Omit(),
        Defaulted<List<String>>? stagedPublicKeyLines = const Omit(),
        Defaulted<List<PendingGeneratedKey>>? pendingGeneratedKeys = const Omit(),
        Defaulted<int>? localKeysRefreshToken = const Omit(),
    }) {
        return SshKeyManagerState(
            loading: loading is Omit ? this.loading : loading as bool,
            applying: applying is Omit ? this.applying : applying as bool,
            error: error is Omit ? this.error : error as String,
            selectedTab: selectedTab is Omit ? this.selectedTab : selectedTab as int,
            authorizedKeysPath: authorizedKeysPath is Omit ? this.authorizedKeysPath : authorizedKeysPath as String?,
            remoteKeys: remoteKeys is Omit ? this.remoteKeys : remoteKeys as List<AuthorizedKeyEntry>,
            stagedPublicKeyLines: stagedPublicKeyLines is Omit ? this.stagedPublicKeyLines : stagedPublicKeyLines as List<String>,
            pendingGeneratedKeys: pendingGeneratedKeys is Omit ? this.pendingGeneratedKeys : pendingGeneratedKeys as List<PendingGeneratedKey>,
            localKeysRefreshToken: localKeysRefreshToken is Omit ? this.localKeysRefreshToken : localKeysRefreshToken as int,
        );
    }
}
