import 'package:flutter/foundation.dart';
import '../model/ConnectWithProfilePasswordMethod.dart';
import '../use_case/my_servers_use_cases.dart';
import 'my_servers_event.dart';
import 'my_servers_state.dart';

class MyServersViewModel extends ChangeNotifier {

    MyServersViewModel({required MyServersUseCases myServersUseCases})
        : _useCases = myServersUseCases
        {
            _init();
        }

    final MyServersUseCases _useCases;
    MyServersState _state = MyServersState();
    MyServersState get state => _state;

    Future<void> _init() async {
        _loadServers();
    }

    Future<void> _loadServers() async {
        _state = _state.copyWith(loading: true);
        _useCases.watchServerProfilesUseCase.execute().forEach((servers) {
            _state = _state.copyWith(servers: servers);
            if (kDebugMode) {
                print("[MyServersViewModel] Profile found: ${_state.servers.length}");
            }
            notifyListeners();
            _state = _state.copyWith(loading: false);
            notifyListeners();
        });
    }

    Future<void> onEvent(MyServersEvent event) async {
        switch (event) {
            case SelectServer():
                _selectServer(event.serverProfileId);
            case EditionMode():
                _editionMode(event.serverProfileId);
            case ConnectWithProfile():
                _connectWithProfileAndMethod(event.method);
        }
    }

    Future<void> _selectServer(int serverProfileId) async {
        if (_state.selectedServerId == serverProfileId) {
           _state = _state.copyWith(selectedServerId: null, editionServerId: null, sshPasswordRequired: false);
        }
        else {
            try {
                final serverProfile = _state.servers.firstWhere((element) => element.id == serverProfileId);
                final bool passwordRequired = await _useCases.checkPasswordRequirementByServerProfileIdUseCase.execute(serverProfileId);

                final bool biometricsAvailable = (serverProfile.securedSshKeyPassword != null);
                if (kDebugMode) {
                    print("[MyServersViewModel] Biometrics availability: $biometricsAvailable");
                }
                _state = _state.copyWith(
                    sshPasswordRequired: passwordRequired,
                    selectedServerId: serverProfileId,
                    biometricsAvailable: biometricsAvailable
                );
            } catch (e) {
                if (kDebugMode) {
                    print("[MyServersViewModel] Error: $e");
                }
            }
        }
        notifyListeners();
    }

    Future<void> _editionMode(int? serverProfileId) async {
        if (serverProfileId == _state.editionServerId) {
          _state = _state.copyWith(editionServerId: null);
        } else {
          _state = _state.copyWith(editionServerId: serverProfileId, selectedServerId: null);
        }
        notifyListeners();
    }

    Future<void> _connectWithProfileAndMethod(ConnectWithProfilePasswordMethod method) async {
        _useCases.authFromProfileUseCase.execute(_state.selectedServerId!, method);
        /*switch (method) {
            case None():
                _connectWithProfile(null);
            case Password():
                _connectWithProfile(method.password);
            case Biometrics():
                // TODO: Handle this case.
                throw UnimplementedError();
        }*/
    }

}