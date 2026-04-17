import 'package:flutter/material.dart';
import 'package:ui/component/app_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SaveServiceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveServiceButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        icon: LucideIcons.save,
        text: "SAVE",
        onClick: onPressed
      ),
    );
  }
}