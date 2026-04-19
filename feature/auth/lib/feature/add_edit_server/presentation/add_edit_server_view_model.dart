import 'dart:async';

import 'package:domain/model/server_profile.dart';
import 'package:domain/use_case/add_edit_server_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../use_case/add_edit_server_use_cases.dart';
import 'add_edit_server_event.dart';
import 'add_edit_server_state.dart';

class AddEditServerViewModel extends ChangeNotifier {

    AddEditServerViewModel({
        required AddEditServerUseCases addEditServerUseCases
    })
        : _useCases = addEditServerUseCases;

    final AddEditServerUseCases _useCases;

    AddEditServerState _state = AddEditServerState();
    AddEditServerState get state => _state;

    final _uiEvent = StreamController<AddEditServerUiEvent>();
    Stream<AddEditServerUiEvent> get uiEvent => _uiEvent.stream;

    Future<void> onEvent(AddEditServerEvent event) async {
        switch (event) {
            case LoadServerProfile():
                _loadServerProfile(event.serverProfileId);
            case SaveEditServer():
                _addEditServer(
                    serverProfileId: event.serverProfileId,
                    name: event.name,
                    user: event.user,
                    url: event.url,
                    port: event.port,
                    sshFilePath: event.sshFilePath
                );
            case LoadSshFile():
                _loadSshFile(event.sshFilePath);
            case DeleteProfile():
                _deleteServerProfile();
        }
    }

    Future<void> _loadServerProfile(int serverProfileId) async {
        final ServerProfile? server = await _useCases.loadServerProfileUseCase.execute(serverProfileId);
         _state = _state.copyWith(serverProfile: server);
         if (server != null) {
            final uiEvent = UpdateFields(
                name: server.name,
                user: server.user,
                url: server.url,
                port: server.port,
                sshFilePath: server.keyPath
            );
            _uiEvent.add(uiEvent);
         }
         notifyListeners();
    }

    void _addEditServer({
        required int? serverProfileId,
        required String name,
        required String user,
        required String url,
        required String port,
        required String sshFilePath,
    }) {
        final AddEditServer server = AddEditServer(
            id: serverProfileId,
            name: name.isEmpty ? null : name,
            url: url,
            port: port,
            user: user,
            sshFilePath: sshFilePath,
            securedSshKeyPassword: _state.serverProfile?.securedSshKeyPassword,
            securedSessionPassword: _state.serverProfile?.securedSessionPassword
        );
        _useCases.addEditServerUseCase.execute(server);
        _uiEvent.add(ExitView());
    }

    Future<void> _deleteServerProfile() async {
        if (kDebugMode) {
            print("[$tag] Deleting server profile");
        }
        final serverProfileId = _state.serverProfile?.id;
        if (serverProfileId != null) {
            await _useCases.deleteServerUseCase.execute(serverProfileId);
        }
        _uiEvent.add(ExitView());
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
            if (kDebugMode) {
                print("[$tag] Couldn't load ssh file: $e");
            }
        }
    }

    static final String tag = "AddEditServerViewModel";

}

sealed class AddEditServerUiEvent {}

class UpdateFields extends AddEditServerUiEvent {
    final String? name;
    final String user;
    final String url;
    final String port;
    final String sshFilePath;

    UpdateFields({
        required this.name,
        required this.user,
        required this.url,
        required this.port,
        required this.sshFilePath
    });
}

class ExitView extends AddEditServerUiEvent {}