import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EscToClose extends StatelessWidget {
  final Widget child;

  const EscToClose({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
        },
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                return null;
              },
            ),
          },
          child: child,
        ),
      ),
    );
  }
}