import 'package:domain/model/ssh/systemctl_command.dart';
import 'package:feature_systemd_services/presentation/service_manager_event.dart';
import 'package:feature_systemd_services/presentation/service_manager_state.dart';
import 'package:feature_systemd_services/feature/edit_service/di/edit_service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/global_error_warning.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'component/service_controller/service_controller.dart';
import 'component/service_manager_loading.dart';

class ServiceManagerScreen extends StatelessWidget {
  final ServiceManagerState state;
  final bool isNarrow;
  final Function(ServiceManagerEvent event) onEvent;

  const ServiceManagerScreen({
    super.key,
    required this.state,
    required this.isNarrow,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: state.loading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
        firstChild: ServiceManagerLoading(),
        secondChild: Stack(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 128),
                    child: Column(
                      children: [
                        if (state.services.any((s) => s.favorite)) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                const Icon(LucideIcons.star),
                                Text(
                                  "Favorites",
                                  style: Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                          ...state.services
                              .where((s) => s.favorite)
                              .map((service) => ServiceController(
                                service: service,
                                onStart: () => onEvent(RunCtlCommand(command: SystemctlCommand.start, service: service.title)),
                                onStop: () => onEvent(RunCtlCommand(command: SystemctlCommand.stop, service: service.title)),
                                onRestart: () => onEvent(RunCtlCommand(command: SystemctlCommand.restart, service: service.title)),
                                onEdit: () => _showEditServiceDialog(context: context, serviceName: service.title),
                                isNarrow: isNarrow,
                              )),
                          ],

                        if (state.services.any((s) => !s.favorite)) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                const Icon(LucideIcons.monitorCog),
                                Text(
                                  "Others",
                                  style: Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            )
                        ),
                        ...state.services
                            .where((s) => !s.favorite)
                            .map((service) => ServiceController(
                              service: service,
                              onStart: () => onEvent(RunCtlCommand(command: SystemctlCommand.start, service: service.title)),
                              onStop: () => onEvent(RunCtlCommand(command: SystemctlCommand.stop, service: service.title)),
                              onRestart: () => onEvent(RunCtlCommand(command: SystemctlCommand.restart, service: service.title)),
                              onEdit: () => _showEditServiceDialog(context: context, serviceName: service.title),
                              isNarrow: isNarrow,
                            )),
                        ]
                      ]
                    ),
                  )
                )
              ],
            ),
            if (state.error.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: AnimatedGlobalErrorWarning(
                    error: state.error,
                    onClose: () => onEvent(CloseError()),
                  ),
                ),
              ),
          ],
        ),
      )
    );
  }

  Future<void> _showEditServiceDialog({
    required BuildContext context,
    required String serviceName
  }) async {
    if (kDebugMode) {
      print("_showEditServiceDialog()");
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDialogLayout(
        padding: EdgeInsets.all(0),
        child: EditServiceProvider(
          serviceName: serviceName,
        ),
      ),
    );
  }
}