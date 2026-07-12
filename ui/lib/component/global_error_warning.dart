import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AnimatedGlobalErrorWarning extends StatelessWidget {
  final String error;
  final Function() onClose;

  const AnimatedGlobalErrorWarning({
    super.key,
    required this.error,
    required this.onClose
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: error.isNotEmpty
          ? GlobalErrorWarning(
            key: ValueKey(error),
            error: error,
            onDismiss: () => onClose(),
          )
          : const SizedBox.shrink(),
      ),
    );
  }

}

class GlobalErrorWarning extends StatelessWidget {
  final String error;
  final Function onDismiss;

  const GlobalErrorWarning({
    super.key,
    required this.error,
    required this.onDismiss
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.triangleAlert,
            color: Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 140, // approx. 7 lines
              ),
              child: SingleChildScrollView(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, color: Colors.red),
            onPressed: () => onDismiss(),
            tooltip: 'Dismiss',
          )
        ],
      ),
    );
  }
}