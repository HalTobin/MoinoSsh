import 'package:flutter/foundation.dart';
import 'package:util/ssh/ssh_key_algorithm.dart';
import 'package:util/ssh/ssh_key_details.dart';

import '../use_case/my_ssh_keys_use_cases.dart';
import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysViewModel extends ChangeNotifier {

    MySshKeysViewModel({
        required MySshKeysUseCases mySshKeysUseCases,
        required bool selectionEnable,
    }) : _useCases = mySshKeysUseCases,
         _selectionEnable = selectionEnable
        {
            _init();
        }

    final MySshKeysUseCases _useCases;
    final bool _selectionEnable;
    MySshKeysState _state = MySshKeysState();
    MySshKeysState get state => _state;

    Future<void> _init() async {
        _setLoadingState(true);
        _loadSshKeys();
    }

    Future<void> onEvent(MySshKeysEvent event) async {
        switch (event) {
            case SelectKey():
                if (_selectionEnable) {
                    _selectKey(event.keyPath);
                }
            case AddKey(): _addKey(event.keyPath);
            case GenerateKey():
                _generateKey(event.name, event.password, event.algorithm);
            case RenameKey(): _renameKey(event.keyPath, event.newName);
            case DeleteKey(): _deleteKey(event.keyPath);
        }
    }

    Future<SshKeyDetails> loadPublicKey(
        String keyPath, {
        String? password,
        String? comment,
    }) {
        return _useCases.getSshKeyDetailsUseCase.execute(
            keyPath,
            password: password,
            comment: comment,
        );
    }

    Future<void> _addKey(String keyPath) async {
        _setLoadingState(true);
        final newFile = await _useCases.addKeyUseCase.execute(keyPath);
        await _loadSshKeys();
        if (_selectionEnable) {
            _selectKey(newFile);
        }
    }

    Future<void> _generateKey(
        String name,
        String? password,
        SshKeyAlgorithm algorithm,
    ) async {
        if (name.trim().isEmpty) {
            return;
        }

        _setLoadingState(true);

        try {
            final generatedKey = await _useCases.generateSshKeyPairUseCase.execute(
                name: name,
                password: password,
                algorithm: algorithm,
            );
            final savedPath = await _useCases.saveSshKeyContentUseCase.execute(
                fileName: generatedKey.privateKeyFileName,
                content: generatedKey.privateKeyContent,
            );

            if (savedPath == null) {
                _setLoadingState(false);
                return;
            }

            await _useCases.saveSshKeyContentUseCase.execute(
                fileName: '${generatedKey.privateKeyFileName}.pub',
                content: '${generatedKey.publicKeyLine}\n',
            );

            await _loadSshKeys();
            if (_selectionEnable) {
                _selectKey(savedPath);
            }
        } catch (error) {
            if (kDebugMode) {
                print('[MySshKeysViewModel] generate key failed: $error');
            }
            _setLoadingState(false);
        }
    }

    Future<void> _loadSshKeys() async {
        final keys = await _useCases.listSshKeysUseCase.execute();
        _state = _state.copyWith(
            keys: keys,
            loading: false
        );
        notifyListeners();
    }

    Future<void> _renameKey(String keyPath, String newName) async {
        _setLoadingState(true);
        final newFile = await _useCases.renameKeyUseCase.execute(keyPath, newName);
        final pubPath = '$keyPath.pub';
        final newPubName = newName.endsWith('.pub') ? newName : '$newName.pub';
        await _useCases.renameKeyUseCase.execute(pubPath, newPubName);
        await _loadSshKeys();
        if (_selectionEnable) {
            _selectKey(newFile);
        }
    }

    Future<void> _deleteKey(String keyPath) async {
        _setLoadingState(true);
        if (_selectionEnable) {
            _selectKey(null);
        }
        await _useCases.deleteKeyUseCase.execute(keyPath);
        await _useCases.deleteKeyUseCase.execute('$keyPath.pub');
        _loadSshKeys();
    }

    void _selectKey(String? keyPath) {
        if (keyPath == _state.selectedKeyPath) {
            _state = _state.copyWith(selectedKeyPath: null);
        }
        else {
            _state = _state.copyWith(selectedKeyPath: keyPath);
        }
        notifyListeners();
    }

    void _setLoadingState(bool state) {
        _state = _state.copyWith(loading: state);
        notifyListeners();
    }

}
