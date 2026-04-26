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
                          _ServiceSection(icon: LucideIcons.star, text: "Favorites"),
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
                          _ServiceSection(icon: LucideIcons.monitorCog, text: "All services"),
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

class _ServiceSection extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ServiceSection({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 12, 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Divider(
              color: colorScheme.outlineVariant,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}