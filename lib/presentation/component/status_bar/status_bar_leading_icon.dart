import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StatusBarLeadingIcon extends StatelessWidget {
  final bool connected;

  const StatusBarLeadingIcon({
    super.key,
    required this.connected
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Center(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstCurve: Curves.easeIn,
          secondCurve: Curves.easeOut,
          crossFadeState: connected
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Icon(LucideIcons.plug, color: colorScheme.onSurface, size: 28),
          secondChild: Icon(LucideIcons.unplug, color: colorScheme.onSurface, size: 28),
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
        ),
      )
    );
  }
}