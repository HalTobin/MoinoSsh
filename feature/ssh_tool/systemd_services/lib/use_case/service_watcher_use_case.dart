import 'dart:async';

import 'package:domain/model/ssh/favorite_service.dart';
import 'package:domain/model/response_result.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:flutter/foundation.dart';

import '../data/icon_set.dart';
import '../data/service_presentation.dart';
import 'notifier/service_status_notifier.dart';

/***
 * TODO - THIS IS NOT A USE_CASE, BUT A SERVICE /!\
 * 1. Migrate this code to ServiceWatcherService
 * 2. Create the following UseCases: 'ListenServicesUseCase' and 'DisposeServiceListenerUseCase'
 *
 * Or just update this class to make sure it automatically dispose itself when there's no listener
 ***/
class ServiceWatcherUseCase {
    ServiceWatcherUseCase({
        required SshService sshService,
        required ServerProfileRepository serverProfileRepository,
        required FavoriteServiceRepository favoriteServiceRepository,
        Duration interval = const Duration(seconds: 5),
    })
        :   _sshService = sshService,
            _serverProfileRepository = serverProfileRepository,
            _favoriteServiceRepository = favoriteServiceRepository,
            _interval = interval
    {
        _servicesStatus.onFirstListenerAdded = _startWatching;
        _servicesStatus.onLastListenerRemoved = _stopWatching;
    }

    final ServerProfileRepository _serverProfileRepository;
    final FavoriteServiceRepository _favoriteServiceRepository;
    final SshService _sshService;
    final Duration _interval;

    final ServiceStatusNotifier _servicesStatus = ServiceStatusNotifier();

    final List<String> _services = [];
    Timer? _timer;

    StreamSubscription<List<FavoriteService>>? _favoritesSubscription;

    Future<ValueListenable<List<ServicePresentation>>> execute() async {
        ResponseResult<List<String>> response = await _sshService.getServiceList();
        switch (response) {
            case ResponseSucceed<List<String>>():
                _services
                    ..clear()
                    ..addAll(response.data);
            case ResponseFailed<List<String>>():
                if (kDebugMode) { print("Failed to retrieve service list"); }
        }
        return _servicesStatus;
    }

    void _startWatching() {
        if (kDebugMode) { print("start watching services states"); }
        _runCheck(); // Immediate check
        _timer = Timer.periodic(_interval, (_) => _runCheck());

        // Start listening to favorite changes
        final sshProfile = _sshService.getCurrentProfile();
        if (sshProfile != null) {
            _serverProfileRepository.getProfileIdByFields(
                url: sshProfile.url,
                port: sshProfile.port,
                user: sshProfile.user,
            ).then((profileId) {
                if (profileId != null) {
                    _favoritesSubscription = _favoriteServiceRepository
                        .watchServicesByProfileId(profileId)
                        .listen((favoriteEntities) {
                            _updateFavorites(favoriteEntities);
                        });
                }
            });
        }
    }

    void _stopWatching() {
        if (kDebugMode) { print("stop watching services states"); }
        _timer?.cancel();
        _timer = null;

        _favoritesSubscription?.cancel();
        _favoritesSubscription = null;
    }

    Future<void> _runCheck() async {
        if (_services.isEmpty) return;

        final sshProfile = _sshService.getCurrentProfile();

        if (sshProfile != null) {
            final profileId = await _serverProfileRepository.getProfileIdByFields(
                url: sshProfile.url,
                port: sshProfile.port,
                user: sshProfile.user
            );

            if (profileId != null) {
                final List<ServicePresentation> result = [];
                final favorites = await _favoriteServiceRepository.getFavoriteServicesByProfileId(profileId);

                for (final service in _services) {
                    FavoriteService? favorite;
                    try {
                        favorite = favorites.firstWhere((f) => f.name == service);
                    } catch (_) {
                        favorite = null;
                    }

                    /*if (favorite != null) {
                        if (kDebugMode) { print("Matching favorite service: ${favorite.toString()}"); }
                    }*/

                    final serviceUi = ServicePresentation(
                        active: await _sshService.isServiceRunning(service),
                        favorite: (favorite != null),
                        title: service,
                        alias: favorite?.alias,
                        icon: ServiceIconType.findById(favorite?.iconId)?.icon
                    );

                    result.add(serviceUi);
                }

                _sortServices(result);
                _servicesStatus.value = result;
            }
            else { if (kDebugMode) { print("current profileId is null"); } }
        }
    }

    void _updateFavorites(List<FavoriteService> favorites) {
        final updatedList = _servicesStatus.value.map((service) {
            final matched = favorites.where((f) => f.name == service.title).firstOrNull;
            return service.copyWith(
                favorite: matched != null,
                alias: matched?.alias,
                icon: ServiceIconType.findById(matched?.iconId)?.icon,
            );
        }).toList();

        _sortServices(updatedList);
        _servicesStatus.value = updatedList;
    }

    void dispose() {
        _stopWatching();
        _servicesStatus.removeListener((){});
        _servicesStatus.dispose();
    }

    void _sortServices(List<ServicePresentation> services) {
        services.sort((a, b) {
            // 1. Favorites first
            if (a.favorite != b.favorite) {
                return a.favorite ? -1 : 1;
            }

            // 2. Within same favorite group, running first
            if (a.active != b.active) {
                return a.active ? -1 : 1;
            }

            // 3. Alphabetical by alias (or title)
            final aName = a.alias?.toLowerCase() ?? a.title.toLowerCase();
            final bName = b.alias?.toLowerCase() ?? b.title.toLowerCase();
            return aName.compareTo(bName);
        });
    }
}