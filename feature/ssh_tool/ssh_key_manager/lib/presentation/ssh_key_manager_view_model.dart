import 'package:domain/model/response_result.dart';
import 'package:flutter/material.dart';
import 'package:util/ssh/public_key_line.dart';

import '../model/apply_authorized_keys_result.dart';
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
            case ToggleRemoteKeyDeletion():
                _toggleRemoteKeyDeletion(event.id);
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
        if (_state.remoteLoading) {
            return;
        }

        _state = _state.copyWith(remoteLoading: true, error: '');
        notifyListeners();

        try {
            final result = await _useCases.getRemoteAuthorizedKeysUseCase.execute();
            switch (result) {
                case ResponseSucceed():
                    // Deletion marks the user already made survive a reload, but
                    // only for keys that are still in the file.
                    final loaded = _state.remoteFile?.transferDeletionsTo(result.data.file) ??
                        result.data.file;
                    _state = _state.copyWith(
                        remoteLoading: false,
                        authorizedKeysPath: result.data.authorizedKeysPath,
                        remoteFile: loaded,
                        remoteFileExists: result.data.fileExists,
                        remoteContentHash: result.data.contentHash,
                    );
                case ResponseFailed():
                    _state = _state.copyWith(
                        remoteLoading: false,
                        error: result.error,
                        remoteFile: null,
                    );
            }
        } catch (error) {
            _state = _state.copyWith(
                remoteLoading: false,
                error: 'Could not load remote keys: $error',
                remoteFile: null,
            );
        }
        notifyListeners();
    }

    void _toggleRemoteKeyDeletion(int id) {
        final file = _state.remoteFile;
        if (file == null) {
            return;
        }

        _state = _state.copyWith(remoteFile: file.toggleDeletion(id), error: '');
        notifyListeners();
    }

    /// Validates before staging, whichever screen the key came from, so nothing
    /// unusable can reach the remote file.
    void _stagePublicKey(String publicKeyLine) {
        switch (SshPublicKeyLine.parse(publicKeyLine)) {
            case SshPublicKeyInvalid(:final message):
                _state = _state.copyWith(error: message);
            case SshPublicKeyValid(:final key):
                if (_state.remoteFile?.containsKey(key) ?? false) {
                    _state = _state.copyWith(
                        error: 'That key is already authorized on this server',
                    );
                } else if (_isAlreadyStaged(key)) {
                    _state = _state.copyWith(error: 'That key is already staged');
                } else {
                    _state = _state.copyWith(
                        // Store the canonical form: one line, single spaces.
                        stagedPublicKeyLines: [
                            ..._state.stagedPublicKeyLines,
                            key.format(),
                        ],
                        error: '',
                    );
                }
        }
        notifyListeners();
    }

    bool _isAlreadyStaged(SshPublicKeyLine key) {
        return _state.stagedPublicKeyLines.any((line) {
            final staged = SshPublicKeyLine.tryParse(line);
            return staged != null && staged.identity == key.identity;
        });
    }

    Future<void> _applyRemoteChanges() async {
        if (!_state.hasPendingRemoteChanges) {
            return;
        }

        final path = _state.authorizedKeysPath;
        final file = _state.remoteFile;
        if (!_state.canApplyRemoteChanges || path == null || file == null) {
            _state = _state.copyWith(
                error: 'Reload the remote keys before applying changes',
            );
            notifyListeners();
            return;
        }

        // What is being written now; anything staged while the write is in
        // flight must survive it.
        final writtenLines = List<String>.unmodifiable(_state.stagedPublicKeyLines);

        _state = _state.copyWith(applying: true, error: '');
        notifyListeners();

        final ApplyAuthorizedKeysResult result;
        try {
            result = await _useCases.applyRemoteAuthorizedKeysUseCase.execute(
                authorizedKeysPath: path,
                file: file,
                stagedPublicKeyLines: writtenLines,
                expectedFileExists: _state.remoteFileExists,
                expectedContentHash: _state.remoteContentHash,
            );
        } catch (error) {
            _state = _state.copyWith(
                applying: false,
                error: 'Could not update remote authorized_keys: $error',
            );
            notifyListeners();
            return;
        }

        switch (result) {
            case ApplyAuthorizedKeysFailed(:final error):
                _state = _state.copyWith(
                    applying: false,
                    error: error.isNotEmpty
                        ? error
                        : 'Could not update remote authorized_keys',
                );
                notifyListeners();
                return;
            case ApplyAuthorizedKeysConflict():
                // Nothing was written. Show the current file so the user can
                // decide again; their staged additions are kept.
                await _loadRemoteKeys();
                _state = _state.copyWith(
                    applying: false,
                    error: 'The file changed on the server, so nothing was written. '
                        'The keys have been reloaded, review the changes and apply again.',
                );
                notifyListeners();
                return;
            case ApplyAuthorizedKeysSucceeded():
                break;
        }

        _state = _state.copyWith(
            applying: false,
            stagedPublicKeyLines: _state.stagedPublicKeyLines
                .where((line) => !writtenLines.contains(line))
                .toList(),
            remoteFile: file.clearDeletions(),
        );
        notifyListeners();

        await _loadRemoteKeys();
    }

    void _discardRemoteChanges() {
        _state = _state.copyWith(
            remoteFile: _state.remoteFile?.clearDeletions(),
            stagedPublicKeyLines: const [],
            error: '',
        );
        notifyListeners();
    }
}
