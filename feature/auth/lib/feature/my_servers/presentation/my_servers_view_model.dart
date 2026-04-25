import 'package:domain/model/ssh/connection_status.dart';
import 'package:feature_auth/feature/my_servers/model/server_profile_ui.dart';
import 'package:flutter/foundation.dart';
import '../model/connect_with_profile_password_method.dart';
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
        _checkBiometricsAvailability();
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

    Future<void> _checkBiometricsAvailability() async {
        final available = await _useCases.checkBiometricsAvailabilityUseCase.execute();
        _state = _state.copyWith(biometricsAvailable: available);
        notifyListeners();
    }

    Future<void> onEvent(MyServersEvent event) async {
        switch (event) {
            case ConnectWithProfile():
                _connectWithProfileAndMethod(profile: event.profile, method: event.method);
        }
    }

    Future<void> _connectWithProfileAndMethod({
        required ServerProfileUi profile,
        required ConnectWithProfilePasswordMethod method
    }) async {
        final succeed = await _useCases.authFromProfileUseCase.execute(profile.id, method) is ConnectionSucceed;
        if (succeed) {
            _state = _state.copyWith(
                sshPasswordRequired: false,
            );
        }
    }

}