import 'package:domain/model/response_result.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/ssh_keys/use_case/save_ssh_key_content_use_case.dart';

import '../use_case/ssh_key_manager_use_cases.dart';
import 'ssh_key_manager_event.dart';
import 'ssh_key_manager_state.dart';

class SshKeyManagerViewModel extends ChangeNotifier {
    SshKeyManagerViewModel({
        required SshKeyManagerUseCases sshKeyManagerUseCases,
        required SaveSshKeyContentUseCase saveSshKeyContentUseCase,
    }) : _useCases = sshKeyManagerUseCases,
         _saveSshKeyContentUseCase = saveSshKeyContentUseCase {
        _init();
    }

    final SshKeyManagerUseCases _useCases;
    final SaveSshKeyContentUseCase _saveSshKeyContentUseCase;
    SshKeyManagerState _state = const SshKeyManagerState();
    SshKeyManagerState get state => _state;

    Future<void> _init() async {
        await _loadRemoteKeys();
    }

    Future<void> onEvent(SshKeyManagerEvent event) async {
        switch (event) {
            case SwitchTab():
                _state = _state.copyWith(selectedTab: event.tabIndex, error: '');
                notifyListeners();
            case ToggleRemoteKeyDeletion():
                _toggleRemoteKeyDeletion(event.line);
            case GenerateKeyPair():
                await _generateKeyPair(event.name);
            case ApplyRemoteChanges():
                await _applyRemoteChanges();
            case DiscardRemoteChanges():
                _discardRemoteChanges();
            case DismissError():
                _state = _state.copyWith(error: '');
                notifyListeners();
            case ReloadRemoteKeys():
                await _loadRemoteKeys();
        }
    }

    Future<void> _loadRemoteKeys() async {
        _state = _state.copyWith(loading: true, error: '');
        notifyListeners();

        final result = await _useCases.getRemoteAuthorizedKeysUseCase.execute();
        switch (result) {
            case ResponseSucceed():
                _state = _state.copyWith(
                    loading: false,
                    authorizedKeysPath: result.data.authorizedKeysPath,
                    remoteKeys: result.data.entries,
                );
            case ResponseFailed():
                _state = _state.copyWith(
                    loading: false,
                    error: result.error,
                );
        }
        notifyListeners();
    }

    void _toggleRemoteKeyDeletion(String line) {
        final updatedKeys = _state.remoteKeys.map((entry) {
            if (entry.line == line) {
                return entry.copyWith(markedForDeletion: !entry.markedForDeletion);
            }
            return entry;
        }).toList();

        _state = _state.copyWith(remoteKeys: updatedKeys, error: '');
        notifyListeners();
    }

    Future<void> _generateKeyPair(String name) async {
        if (name.trim().isEmpty) {
            _state = _state.copyWith(error: 'Key name is required');
            notifyListeners();
            return;
        }

        _state = _state.copyWith(loading: true, error: '');
        notifyListeners();

        try {
            final pendingKey = await _useCases.generateSshKeyPairUseCase.execute(name: name);
            _state = _state.copyWith(
                loading: false,
                stagedPublicKeyLines: [
                    ..._state.stagedPublicKeyLines,
                    pendingKey.publicKeyLine,
                ],
                pendingGeneratedKeys: [
                    ..._state.pendingGeneratedKeys,
                    pendingKey,
                ],
            );
        } catch (error) {
            if (kDebugMode) {
                print('[SshKeyManagerViewModel] generate key failed: $error');
            }
            _state = _state.copyWith(
                loading: false,
                error: 'Could not generate SSH key pair',
            );
        }
        notifyListeners();
    }

    Future<void> _applyRemoteChanges() async {
        if (!_state.hasPendingRemoteChanges) {
            return;
        }

        final path = _state.authorizedKeysPath;
        if (path == null) {
            _state = _state.copyWith(error: 'Remote authorized_keys path is unavailable');
            notifyListeners();
            return;
        }

        _state = _state.copyWith(applying: true, error: '');
        notifyListeners();

        final applied = await _useCases.applyRemoteAuthorizedKeysUseCase.execute(
            authorizedKeysPath: path,
            currentEntries: _state.remoteKeys,
            stagedPublicKeyLines: _state.stagedPublicKeyLines,
        );

        if (!applied) {
            _state = _state.copyWith(
                applying: false,
                error: 'Could not update remote authorized_keys',
            );
            notifyListeners();
            return;
        }

        for (final pendingKey in _state.pendingGeneratedKeys) {
            await _saveSshKeyContentUseCase.execute(
                fileName: pendingKey.privateKeyFileName,
                content: pendingKey.privateKeyContent,
            );
        }

        _state = _state.copyWith(
            applying: false,
            stagedPublicKeyLines: const [],
            pendingGeneratedKeys: const [],
            localKeysRefreshToken: _state.localKeysRefreshToken + 1,
        );
        notifyListeners();

        await _loadRemoteKeys();
    }

    void _discardRemoteChanges() {
        final resetKeys = _state.remoteKeys
            .map((entry) => entry.copyWith(markedForDeletion: false))
            .toList();

        _state = _state.copyWith(
            remoteKeys: resetKeys,
            stagedPublicKeyLines: const [],
            pendingGeneratedKeys: const [],
            error: '',
        );
        notifyListeners();
    }
}
