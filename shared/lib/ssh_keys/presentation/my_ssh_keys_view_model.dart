import 'package:flutter/material.dart';

import '../use_case/my_ssh_keys_use_cases.dart';
import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysViewModel extends ChangeNotifier {

    MySshKeysViewModel({required MySshKeysUseCases mySshKeysUseCases})
        : _useCases = mySshKeysUseCases
        {
            _init();
        }

    final MySshKeysUseCases _useCases;
    MySshKeysState _state = MySshKeysState();
    MySshKeysState get state => _state;

    Future<void> _init() async {
        _setLoadingState(true);
        _loadSshKeys();
    }

    Future<void> onEvent(MySshKeysEvent event) async {
        switch (event) {
            case SelectKey(): _selectKey(event.keyPath);
            case EditionMode(): _editionMode(event.keyPath);
            case AddKey(): _addKey(event.keyPath);
            case RenameKey(): _renameKey(event.keyPath, event.newName);
            case DeleteKey(): _deleteKey(event.keyPath);
        }
    }

    Future<void> _addKey(String keyPath) async {
        _setLoadingState(true);
        final newFile = await _useCases.addKeyUseCase.execute(keyPath);
        _loadSshKeys();
        _selectKey(newFile);
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
        _loadSshKeys();
        _selectKey(newFile);
    }

    Future<void> _deleteKey(String keyPath) async {
        _setLoadingState(true);
        _selectKey(null);
        await _useCases.deleteKeyUseCase.execute(keyPath);
        _loadSshKeys();
    }

    void _selectKey(String? keyPath) {
        if (keyPath == _state.selectedKeyPath) {
            _state = _state.copyWith(selectedKeyPath: null, editionModeKeyPath: null);
        }
        else {
            _state = _state.copyWith(selectedKeyPath: keyPath, editionModeKeyPath: null);
        }
        notifyListeners();
    }

    void _editionMode(String? keyPath) {
        if (keyPath == _state.editionModeKeyPath) {
            _state = _state.copyWith(editionModeKeyPath: null, selectedKeyPath: null);
        }
        else {
            _state = _state.copyWith(editionModeKeyPath: keyPath, selectedKeyPath: null);
        }
        notifyListeners();
    }

    void _setLoadingState(bool state) {
        _state = _state.copyWith(loading: state);
        notifyListeners();
    }

}