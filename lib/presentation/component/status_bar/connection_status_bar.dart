import 'package:flutter/material.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_background.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_connect_button.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_leading_icon.dart';
import 'package:ls_server_app/presentation/main_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ConnectionStatusBar extends StatelessWidget implements PreferredSizeWidget {
  final MainState state;
  final Function logOut;
  final Function openSettings;

  const ConnectionStatusBar({
    super.key,
    required this.state,
    required this.logOut,
    required this.openSettings
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StatusBarBackground(connected: state.isConnected),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //leadingWidth: 128,
          leading: Row(
            children: [
              SizedBox(width: 8),
              IconButton(
                onPressed: () { openSettings(); },
                icon: const Icon(LucideIcons.settings, color: Colors.white, size: 28)
              )
            ]
          ),
          title: Row(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusBarLeadingIcon(connected: state.isConnected),
              Text(
                state.profile.isBlank()
                    ? "No current connection"
                    : state.profile.getIdentifier(),
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          actions: [
            StatusBarConnectButton(
              connected: state.isConnected,
              onPressed: () {
                if (state.isConnected) { logOut(); }
              }
            )
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}