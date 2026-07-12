import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SaveIconButton extends StatelessWidget {
  final bool editMode;
  final Function() onPressed;

  const SaveIconButton({
    super.key,
    required this.editMode,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(milliseconds: 300);
    return AnimatedSize(
      duration: duration,
      child: AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: editMode
        ? IconButton(
          key: const ValueKey('save_button'),
          icon: const Icon(LucideIcons.save),
          onPressed: () => onPressed(),
        )
        : const SizedBox.shrink(key: ValueKey('empty')),
    ),
    );
  }

}