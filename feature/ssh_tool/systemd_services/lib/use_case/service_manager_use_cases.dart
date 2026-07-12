import 'package:feature_systemd_services/use_case/run_systemctl_command_use_case.dart';
import 'package:feature_systemd_services/use_case/service_watcher_use_case.dart';

class ServiceManagerUseCases {
    final RunSystemctlCommandUseCase runSystemctlCommandUseCase;
    final ServiceWatcherUseCase serviceWatcherUseCase;

    ServiceManagerUseCases({
        required this.runSystemctlCommandUseCase,
        required this.serviceWatcherUseCase
    });
}