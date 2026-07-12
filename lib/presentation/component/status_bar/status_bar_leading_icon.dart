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
          firstChild: const Icon(LucideIcons.plug, color: Colors.white, size: 28),
          secondChild: const Icon(LucideIcons.unplug, color: Colors.white, size: 28),
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