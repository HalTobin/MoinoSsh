import 'package:collection/collection.dart';
import 'package:domain/model/ssh/systemctl_command.dart';
import 'package:feature_systemd_services/presentation/service_manager_event.dart';
import 'package:feature_systemd_services/presentation/service_manager_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/component/title_header.dart';
import 'package:feature_systemd_services/presentation/component/service_controller/service_status_indicator.dart';

class ManageServiceModal extends StatelessWidget {
  final String serviceTitle;
  final Function() onEdit;

  const ManageServiceModal({
    super.key,
    required this.serviceTitle,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceManagerViewmodel>();
    final state = viewModel.state;
    final onEvent = viewModel.onEvent;

    final service = state.services.firstWhereOrNull((service) => service.title == serviceTitle);

    final padding = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.directional(top: padding, bottom: 0, start: padding, end: padding/2),
          child: TitleHeader(
            icon: LucideIcons.monitorCog,
            title: "Pinned folders",
            trailingContent: TitleHeaderTrailingContent.dismissable(
              onDismiss: () => Navigator.of(context).pop()
            )
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: (service != null)
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ServiceStatusIndicator(
                        service: service,
                        active: service.active,
                        isNarrow: true
                      )
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(LucideIcons.pen)
                    )
                  ],
                ),
                if (service.active)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      _ManageServiceIconButton(
                        icon: LucideIcons.rotateCcw,
                        color: Colors.orange,
                        onPressed: () => onEvent(RunCtlCommand(command: SystemctlCommand.restart, service: service.title))
                      ),
                      Expanded(
                        child: _ManageServiceExpandedButton(
                          text: "Stop".toUpperCase(),
                          color: Colors.red,
                          onPressed: () => onEvent(RunCtlCommand(command: SystemctlCommand.stop, service: service.title))
                        )
                      )
                    ],
                  )
                else
                  _ManageServiceExpandedButton(
                    text: "Start".toUpperCase(),
                    color: Colors.green,
                    onPressed: () => onEvent(RunCtlCommand(command: SystemctlCommand.start, service: service.title))
                  )
              ],
            )
          : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Icon(
                LucideIcons.cloudAlert,
                color: Theme.of(context).colorScheme.error,
              ),
              Text(
                "An error has occur",
                style: TextStyle(color: Theme.of(context).colorScheme.error)
              )
            ],
          ),
        )

      ]
    );
  }

}

class _ManageServiceExpandedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;

  const _ManageServiceExpandedButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
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
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        icon: Icon(icon),
     ),
    );
  }

}