import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

sealed class TitleHeaderTrailingContent {
  const TitleHeaderTrailingContent();

  static TitleHeaderTrailingContent none() => const None();

  static TitleHeaderTrailingContent dismissable({required VoidCallback onDismiss}) =>
      Dismissable(onDismiss: onDismiss);

  static TitleHeaderTrailingContent action({
    required IconData icon,
    required VoidCallback onPressed,
  }) => Action(icon: icon, onPressed: onPressed);
}

class None extends TitleHeaderTrailingContent {
  const None();
}

class Dismissable extends TitleHeaderTrailingContent {
  final VoidCallback onDismiss;
  const Dismissable({required this.onDismiss});
}

class Action extends TitleHeaderTrailingContent {
  final IconData icon;
  final VoidCallback onPressed;

  const Action({
    required this.icon,
    required this.onPressed,
  });
}

class TitleHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final TitleHeaderTrailingContent trailingContent;

  const TitleHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailingContent = const None()
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Icon(
          icon,
          size: 28,
          color: Theme.of(context).colorScheme.primary
        ),
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: SizedBox.shrink()
        ),
        switch (trailingContent) {
          None() => const SizedBox.shrink(),
          Dismissable(onDismiss: var callback) => IconButton(
            onPressed: callback,
            icon: const Icon(LucideIcons.x),
          ),
          Action(icon: final icon, onPressed: final onPressed) => _TitleHeaderAction(
            icon: icon,
            onPressed: onPressed,
          ),
        }
      ],
    );
  }
}

class _TitleHeaderAction extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const _TitleHeaderAction({
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}