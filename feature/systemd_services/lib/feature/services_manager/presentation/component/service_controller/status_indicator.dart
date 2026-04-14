import 'package:feature_systemd_services/feature/services_manager/presentation/component/service_controller/play_ripple_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../data/service_presentation.dart';

class StatusIndicator extends StatelessWidget {
  final ServicePresentation service;
  final bool active;

  const StatusIndicator({
    super.key,
    required this.service,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        active
          ? const PlayRippleIndicator()
          : const Icon(LucideIcons.circlePause, color: Colors.grey),
        Icon(service.icon, color: Theme.of(context).colorScheme.primary),
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (service.alias ?? service.title).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (service.alias != null)
                Text(
                  service.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
            ],
          )
        )
      ],
    );
  }
}