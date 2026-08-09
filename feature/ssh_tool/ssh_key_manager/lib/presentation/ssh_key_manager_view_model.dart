import 'package:domain/model/response_result.dart';
import 'package:flutter/material.dart';

import '../use_case/ssh_key_manager_use_cases.dart';
import 'ssh_key_manager_event.dart';
import 'ssh_key_manager_state.dart';

class SshKeyManagerViewModel extends ChangeNotifier {
    SshKeyManagerViewModel({
        required SshKeyManagerUseCases sshKeyManagerUseCases,
    }) : _useCases = sshKeyManagerUseCases {
        _init();
    }

    final SshKeyManagerUseCases _useCases;
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
            case StagePublicKey():
                _stagePublicKey(event.publicKeyLine);
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
        _state = _state.copyWith(remoteLoading: true, error: '');
        notifyListeners();

        final result = await _useCases.getRemoteAuthorizedKeysUseCase.execute();
        switch (result) {
            case ResponseSucceed():
                _state = _state.copyWith(
                    remoteLoading: false,
                    authorizedKeysPath: result.data.authorizedKeysPath,
                    remoteKeys: result.data.entries,
                );
            case ResponseFailed():
                _state = _state.copyWith(
                    remoteLoading: false,
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

    void _stagePublicKey(String publicKeyLine) {
        final trimmed = publicKeyLine.trim();
        if (trimmed.isEmpty) {
            return;
        }

        if (_state.stagedPublicKeyLines.contains(trimmed)) {
            return;
        }

        _state = _state.copyWith(
            stagedPublicKeyLines: [
                ..._state.stagedPublicKeyLines,
                trimmed,
            ],
            error: '',
        );
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

        _state = _state.copyWith(
            applying: false,
            stagedPublicKeyLines: const [],
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
            error: '',
        );
        notifyListeners();
    }
}
