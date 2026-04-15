import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StatusBarConnectButton extends StatelessWidget {
  final bool connected;
  final Function() onPressed;
  final bool isNarrow;

  const StatusBarConnectButton({
    super.key,
    required this.connected,
    required this.onPressed,
    required this.isNarrow
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: connected,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
          opacity: connected ? 1 : 0,
          child: ConnectionButton(
            connected: true,
            onPressed: onPressed,
            isNarrow: isNarrow,
          )
        )
      )
    );
  }
}

class ConnectionButton extends StatelessWidget {
  final bool connected;
  final Function() onPressed;
  final bool isNarrow;

  const ConnectionButton({
    super.key,
    required this.connected,
    required this.onPressed,
    required this.isNarrow
  });

  @override
  Widget build(BuildContext context) {
    if (!isNarrow) {
      return TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              connected ? 'DISCONNECT' : 'CONNECT',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(
              connected ? LucideIcons.logOut : LucideIcons.logIn,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    else {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(
          connected ? LucideIcons.logOut : LucideIcons.logIn,
          color: Colors.white,
        )
      );
    }
  }
}