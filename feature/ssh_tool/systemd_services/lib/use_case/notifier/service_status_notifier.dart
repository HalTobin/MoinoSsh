import 'package:flutter/material.dart';

import '../../data/service_presentation.dart';

class ServiceStatusNotifier extends ValueNotifier<List<ServicePresentation>> {
    ServiceStatusNotifier() : super([]);

    final List<VoidCallback> _externalListeners = [];

    @override
    void addListener(VoidCallback listener) {
        super.addListener(listener);
        _externalListeners.add(listener);
        if (_externalListeners.length == 1) {
            // First external listener added
            onFirstListenerAdded?.call();
        }
    }

    @override
    void removeListener(VoidCallback listener) {
        super.removeListener(listener);
        _externalListeners.remove(listener);
        if (_externalListeners.isEmpty) {
            // Last external listener removed
            onLastListenerRemoved?.call();
        }
    }

    VoidCallback? onFirstListenerAdded;
    VoidCallback? onLastListenerRemoved;
}