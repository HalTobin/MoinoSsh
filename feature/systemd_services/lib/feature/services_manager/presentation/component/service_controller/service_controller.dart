import 'package:feature_systemd_services/feature/services_manager/presentation/component/service_controller/service_action_button.dart';
import 'package:feature_systemd_services/feature/services_manager/presentation/component/service_controller/status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../data/service_presentation.dart';

class ServiceController extends StatelessWidget {
  final ServicePresentation service;
  final Function() onStart;
  final Function() onStop;
  final Function() onRestart;
  final Function() onEdit;
  final bool isNarrow;

  const ServiceController({
    super.key,
    required this.service,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onEdit,
    required this.isNarrow
  });

  @override
  Widget build(BuildContext context) {
    if (!isNarrow) {
      return _ServiceControllerContent(
        service: service,
        onStart: onStart,
        onStop: onStop,
        onRestart: onRestart,
        onEdit: onEdit,
        isNarrow: isNarrow,
      );
    }
    else {
      return InkWell(
        onTap: onEdit,
        child: _ServiceControllerContent(
          service: service,
          onStart: onStart,
          onStop: onStop,
          onRestart: onRestart,
          onEdit: onEdit,
          isNarrow: isNarrow,
        ),
      );
    }
  }
}

class _ServiceControllerContent extends StatelessWidget {
  final ServicePresentation service;
  final Function() onStart;
  final Function() onStop;
  final Function() onRestart;
  final Function() onEdit;
  final bool isNarrow;

  const _ServiceControllerContent({
    super.key,
    required this.service,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onEdit,
    required this.isNarrow
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Flexible(
            child: StatusIndicator(
              service: service,
              active: service.active,
              isNarrow: isNarrow,
            ),
          ),
          if (service.active)
            AnimatedServiceActionButton(
              enable: service.active,
              icon: LucideIcons.square,
              color: Colors.red,
              onPressed: service.active ? onStop : null,
            ),
          if (service.active)
            AnimatedServiceActionButton(
              enable: service.active,
              icon: LucideIcons.rotateCcw,
              color: Colors.orange,
              onPressed: service.active ? onRestart : null,
            ),
          if (!service.active)
            AnimatedServiceActionButton(
              enable: !service.active,
              icon: LucideIcons.play,
              color: Colors.green,
              onPressed: service.active ? null : onStart,
            ),
          if (!isNarrow)
            IconButton(
                onPressed: onEdit,
                icon: Icon(LucideIcons.pencil)
            ),
        ],
      ),
    );
  }

}