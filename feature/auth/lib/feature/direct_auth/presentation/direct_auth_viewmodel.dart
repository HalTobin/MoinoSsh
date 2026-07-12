import 'dart:isolate';
import 'package:domain/model/ssh_connect_fields.dart';
import 'package:domain/use_case/ssh_connect_use_case.dart';
import 'package:flutter/foundation.dart';

import '../use_case/direct_auth_use_cases.dart';
import 'direct_auth_event.dart';
import 'direct_auth_state.dart';

class DirectAuthViewModel extends ChangeNotifier {

    DirectAuthViewModel({required DirectAuthUseCases directAuthUseCases})
        : _useCases = directAuthUseCases;

    final DirectAuthUseCases _useCases;
    DirectAuthState _state = DirectAuthState();
    DirectAuthState get state => _state;

    Future<void> onEvent(DirectAuthEvent event) async {
        switch (event) {
            case LoadSshFile():
                _loadSshFile(event.sshFilePath);
            case Connect(): {
                _setLoadingState(true);
                final bool fieldsValid = _checkFields(
                    user: event.user,
                    url: event.serverUrl,
                    port: event.serverPort,
                    filePath: event.sshFilePath,
                    password: event.password
                );
                if (fieldsValid) {
                    _connect(
                        user: event.user,
                        url: event.serverUrl,
                        port: event.serverPort,
                        filePath: event.sshFilePath,
                        password: event.password
                    );
                }
                _setLoadingState(false);
            }
            case ClearError():
              _clearError();
        }
    }

    bool _checkFields({
        required String user,
        required String url,
        required String port,
        required String filePath,
        required String? password
    }) {
        final List<SshConnectFields> wrongFields = _useCases.checkWrongFieldsUseCase.execute(
            user: user,
            url: url,
            port: port,
            filePath: filePath,
            password: password,
            passwordRequired: _state.passwordRequired
        );

        _state = _state.copyWith(
            wrongFields: wrongFields
        );
        notifyListeners();

        return wrongFields.isEmpty;
    }

    Future<void> _connect({
        required String user,
        required String url,
        required String port,
        required String filePath,
        required String? password,
    }) async {
        _setLoadingState(true);
        await Isolate.run(() {
            final connectDto = SshConnectRequest(
                user: user,
                url: url,
                port: port,
                filePath: filePath,
                password: password ?? ""
            );
            _useCases.sshConnectUseCase.execute(connectDto);
        });
        _setLoadingState(false);
    }
        /*_setLoadingState(true);
        final connectDto = SshConnectRequest(
            user: user,
            url: url,
            port: port,
            filePath: filePath,
            password: password,
            passwordRequestCallback: passwordRequestCallback
        );
        _useCases.sshConnectUseCase.execute(connectDto);
        _setLoadingState(false);*/
    //}

    void _clearError() {
        _state = _state.copyWith(globalError: "");
        notifyListeners();
    }

    void _loadSshFile(String filePath) {
        try {
            final bool isPasswordRequired = _useCases.loadSshFileUseCase.execute(filePath);
            _state = _state.copyWith(
                passwordRequired: isPasswordRequired,
                sshFilePath: filePath
            );
            notifyListeners();
        } catch (e) {
            if (kDebugMode) { print("Couldn't load ssh file: $e"); }
        }
    }

    void _setLoadingState(bool loading) {
        _state = _state.copyWith(loading: loading);
        notifyListeners();
    }

}