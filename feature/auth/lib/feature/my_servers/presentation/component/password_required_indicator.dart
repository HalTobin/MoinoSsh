import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PasswordRequiredIndicator extends StatelessWidget {
  final bool enable;

  const PasswordRequiredIndicator({
    super.key,
    required this.enable
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: enable ? 40 : 0,
        child: Center(
          child: AnimatedOpacity(
            opacity: enable ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.lock,
                  color: Colors.green,
                  size: 18
                ),
                const Text(
                  "This file is protected by a password.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}