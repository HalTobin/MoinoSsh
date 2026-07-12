import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditIconButton extends StatelessWidget {
  final bool editMode;
  final Function onPressed;

  const EditIconButton({
    super.key,
    required this.editMode,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: IconButton(
        onPressed: () => onPressed(),
        icon: const Icon(LucideIcons.penOff)
      ),
      secondChild: IconButton(
        onPressed: () => onPressed(),
        icon: const Icon(LucideIcons.pen)
      ),
      crossFadeState: editMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300)
    );
  }

}