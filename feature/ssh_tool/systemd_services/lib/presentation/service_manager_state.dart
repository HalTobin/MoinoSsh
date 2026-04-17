import '../data/service_presentation.dart';

class ServiceManagerState {
    final bool isConnected;
    final bool loading;
    final List<ServicePresentation> services;
    final String error;

    ServiceManagerState({
        this.services = const [],
        this.loading = false,
        this.isConnected = false,
        this.error = ""
    });

    ServiceManagerState copyWith({
        bool? isConnected,
        bool? loading,
        List<ServicePresentation>? services,
        String? error
    }) {
        return ServiceManagerState(
            isConnected: isConnected ?? this.isConnected,
            loading: loading ?? this.loading,
            services: services ?? this.services,
            error: error ?? this.error
        );
    }
}