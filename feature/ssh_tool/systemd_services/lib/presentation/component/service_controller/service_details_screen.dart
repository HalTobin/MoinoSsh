import 'package:collection/collection.dart';
import 'package:domain/model/ssh/systemctl_command.dart';
import 'package:feature_systemd_services/presentation/component/service_controller/service_status_indicator.dart';
import 'package:feature_systemd_services/presentation/service_manager_event.dart';
import 'package:feature_systemd_services/presentation/service_manager_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/component/title_header.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceTitle;
  final Function() onEdit;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceTitle,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceManagerViewmodel>();
    final state = viewModel.state;
    final onEvent = viewModel.onEvent;
    final service = state.services.firstWhereOrNull((s) => s.title == serviceTitle);
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: TitleHeader(
                icon: LucideIcons.monitorCog,
                title: "Service details",
                trailingContent: TitleHeaderTrailingContent.dismissable(
                  onDismiss: () => Navigator.of(context).pop()
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: service != null
                ? ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ServiceStatusIndicator(
                              service: service,
                              active: service.active,
                              isNarrow: true,
                            ),
                          ),
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(LucideIcons.pen),
                            tooltip: "Edit",
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _DetailRow(
                        label: "Name",
                        value: service.title,
                      ),
                      if (service.alias != null)
                        _DetailRow(
                          label: "Alias",
                          value: service.alias!,
                        ),
                      _DetailRow(
                        label: "Status",
                        value: service.active ? "Running" : "Stopped",
                        valueColor: service.active ? Colors.green : Colors.red,
                      ),
                      _DetailRow(
                        label: "Favorite",
                        value: service.favorite ? "Yes" : "No",
                      ),
                    ],
                  )
                : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        Icon(
                          LucideIcons.cloudAlert,
                          color: colorScheme.error,
                        ),
                        Text(
                          "An error has occurred",
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ],
                    ),
                  ),
            ),
            if (service != null)
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomPadding),
                child: service.active
                  ? Row(
                      spacing: 12,
                      children: [
                        _ManageServiceIconButton(
                          icon: LucideIcons.rotateCcw,
                          color: Colors.orange,
                          onPressed: () => onEvent(RunCtlCommand(
                            command: SystemctlCommand.restart,
                            service: service.title,
                          )),
                        ),
                        Expanded(
                          child: _ManageServiceExpandedButton(
                            text: "Stop".toUpperCase(),
                            color: Colors.red,
                            onPressed: () => onEvent(RunCtlCommand(
                              command: SystemctlCommand.stop,
                              service: service.title,
                            )),
                          ),
                        ),
                      ],
                    )
                  : _ManageServiceExpandedButton(
                      text: "Start".toUpperCase(),
                      color: Colors.green,
                      onPressed: () => onEvent(RunCtlCommand(
                        command: SystemctlCommand.start,
                        service: service.title,
                      )),
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageServiceExpandedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;

  const _ManageServiceExpandedButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            const StadiumBorder(),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ManageServiceIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function() onPressed;

  const _ManageServiceIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton.filled(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          backgroundColor: WidgetStateProperty.all<Color>(color),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            const StadiumBorder(),
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
