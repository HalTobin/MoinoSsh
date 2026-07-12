import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SshConnectButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;

  const SshConnectButton({
    super.key,
    required this.onPressed,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 384),
        child: SizedBox(
          height: 48,
          child: FilledButton.icon(
            onPressed: loading ? null : onPressed,
            icon: loading ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ) : Icon(LucideIcons.earthLock),
            label: const Text('CONNECT'),
          ),
        ),
      ),
    );
  }
}