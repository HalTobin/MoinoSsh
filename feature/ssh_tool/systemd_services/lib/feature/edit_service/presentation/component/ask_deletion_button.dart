import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AskDeletionButton extends StatelessWidget {
  final bool deleteMode;
  final Function onClick;

  const AskDeletionButton({
    super.key,
    required this.deleteMode,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: IconButton(
          onPressed: () => onClick(),
          color: Theme.of(context).colorScheme.error,
          icon: const Icon(LucideIcons.trash)
      ),
      secondChild: IconButton(
          onPressed: () => onClick(),
          icon: const Icon(LucideIcons.pencil)
      ),
      crossFadeState: deleteMode
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
      layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              key: bottomKey,
              child: bottomChild,
            ),
            Positioned(
              key: topKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}