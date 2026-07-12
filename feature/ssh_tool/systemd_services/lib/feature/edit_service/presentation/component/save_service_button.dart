import 'package:flutter/material.dart';
import 'package:ui/component/app_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SaveServiceButton extends StatelessWidget {
  final bool centered;
  final VoidCallback onPressed;

  const SaveServiceButton({
    super.key,
    required this.centered,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    if (centered) {
      return SizedBox(
        height: 40,
        child: FilledButton.icon(
          onPressed: onPressed,
          label: Text("SAVE"),
          icon: Icon(LucideIcons.save)
        ),
      );
    }
    else {
      return SizedBox(
        height: 40,
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onPressed,
          label: Text("SAVE"),
          icon: Icon(LucideIcons.save)
        ),
      );
    }
  }
}