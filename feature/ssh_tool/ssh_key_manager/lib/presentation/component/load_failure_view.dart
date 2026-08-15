import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';

class LoadFailureView extends StatelessWidget {
  final String error;
  final Function() onRetry;

  const LoadFailureView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.keyRound, size: 64),
            Text(
              'Could not read the remote authorized_keys file',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              error.isNotEmpty
                  ? error
                  : 'Check the connection to the server and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            AppButton(
              onClick: onRetry,
              text: 'RETRY',
              icon: LucideIcons.refreshCw,
            ),
          ],
        ),
      ),
    );
  }
}
