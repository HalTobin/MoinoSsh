import 'package:domain/model/response_result.dart';
import 'package:feature_systemd_services/presentation/service_manager_event.dart';
import 'package:feature_systemd_services/presentation/service_manager_state.dart';
import 'package:flutter/foundation.dart';

import '../data/service_presentation.dart';
import '../use_case/service_manager_use_cases.dart';

class ServiceManagerViewmodel extends ChangeNotifier {

    ServiceManagerViewmodel({required ServiceManagerUseCases serviceManagerUseCases})
      : _useCases = serviceManagerUseCases
    {
        if (kDebugMode) {
            print("[$tag] init()");
        }
        _init();
    }

    final ServiceManagerUseCases _useCases;
    ServiceManagerState _state = ServiceManagerState();
    ServiceManagerState get state => _state;

    ValueListenable<List<ServicePresentation>>? _serviceStatusNotifier;
    VoidCallback? _serviceStatusListener;

    Future<void> _init() async {
        _updateLoadingStatus(true);
        _observeServicesStatus();
    }

    Future<void> onEvent(ServiceManagerEvent event) async {
        switch (event) {
            case RunCtlCommand(): {
                final ResponseResult<bool> response = await _useCases.runSystemctlCommandUseCase
                    .execute(
                        command: event.command,
                        service: event.service
                    );
                switch (response) {
                    case ResponseFailed():
                        _setError(response.error);
                    case ResponseSucceed():
                        _setError("");
                }
            }
            case CloseError():
                _setError("");
        }
    }

    void _setError(String error) {
        _state = _state.copyWith(error: error);
        notifyListeners();
    }

    Future<void> _observeServicesStatus() async {
        _serviceStatusNotifier?.removeListener(_serviceStatusListener!);
        _serviceStatusNotifier = await _useCases.serviceWatcherUseCase.execute();
        _serviceStatusListener = () {
            final services = _serviceStatusNotifier!.value;
            _state = _state.copyWith(services: services, loading: false);
            notifyListeners();
        };
        _serviceStatusNotifier!.addListener(_serviceStatusListener!);
    }

    void _stopObservingServiceStatuses() {
        if (kDebugMode) {
            print("[$tag] Stop listening services status");
        }
        if (_serviceStatusNotifier != null && _serviceStatusListener != null) {
            _serviceStatusNotifier!.removeListener(_serviceStatusListener!);
            _serviceStatusNotifier = null;
            _serviceStatusListener = null;
        }
    }

    void _updateLoadingStatus(bool status) {
        _state = _state.copyWith(loading: status);
        notifyListeners();
    }

    @override
    void dispose() {
        if (kDebugMode) {
            print("[$tag] dispose()");
        }
        _stopObservingServiceStatuses();
        super.dispose();
    }

    static final String tag = "ServiceManagerViewModel";

}