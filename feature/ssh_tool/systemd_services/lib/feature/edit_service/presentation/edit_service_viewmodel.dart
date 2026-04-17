import 'package:domain/model/ssh/favorite_service.dart';
import 'package:flutter/foundation.dart';

import '../use_case/edit_service_use_cases.dart';
import 'edit_service_event.dart';
import 'edit_service_state.dart';

class EditServiceViewModel extends ChangeNotifier {

    EditServiceViewModel({
        required String serviceName,
        required EditServiceUseCases editServiceUseCases,
        required Function(EditServiceUiEvent) uiEvent
    })
      : _useCases = editServiceUseCases,
        _serviceName = serviceName,
        _uiEvent = uiEvent
      {
          _init(_serviceName);
      }

    final String _serviceName;
    final EditServiceUseCases _useCases;
    final Function(EditServiceUiEvent) _uiEvent;

    EditServiceState _state = EditServiceState();
    EditServiceState get state => _state;

    Future<void> _init(String serviceName) async {
        final FavoriteService? service = await _useCases.getServiceUseCase.execute(serviceName: serviceName);
        _state = _state.copyWith(
            serviceName: serviceName,
            serviceId: service?.id,
            alias: service?.alias,
            iconId: service?.iconId
        );
        notifyListeners();
    }

    void onEvent(EditServiceEvent event) {
        switch (event) {
            case SaveService():
                _upsertService(
                    serviceName: _serviceName,
                    alias: event.alias,
                    iconId: _state.iconId
                );
            case AskDeleteService():
                _updateDeleteMode(true);
            case ExitDeleteMode():
                _updateDeleteMode(false);
            case ConfirmDeleteService():
                _deleteService();
            case SelectIcon():
                _selectIcon(event.iconId);

        }
    }

    Future<void> _upsertService({
        required String serviceName,
        required String alias,
        required int iconId
    }) async {
        _useCases.upsertServiceToFavoriteUseCase.execute(
            serviceName: serviceName,
            alias: (alias.isEmpty) ? null : alias,
            iconId: (_state.iconId == -1) ? null : _state.iconId
        );
        _uiEvent(ExitDialog());
    }

    Future<void> _deleteService() async {
        if (_state.serviceId != -1) {
            _useCases.deleteServiceFromFavoriteUseCase.execute(serviceId: _state.serviceId);
        }
        _uiEvent(ExitDialog());
    }

    void _selectIcon(int? iconId) {
        if (iconId != null) {
            _state = _state.copyWith(iconId: iconId);
        }
        else {
            _state = _state.copyWith(iconId: -1);
        }
        notifyListeners();
    }

    void _updateDeleteMode(bool value) {
        _state = _state.copyWith(deleteMode: value);
        notifyListeners();
    }

}

sealed class EditServiceUiEvent {}

class ExitDialog extends EditServiceUiEvent {}