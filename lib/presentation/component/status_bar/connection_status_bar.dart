import 'package:domain/model/ssh/ssh_profile.dart';
import 'package:flutter/material.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_background.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_connect_button.dart';
import 'package:ls_server_app/presentation/component/status_bar/status_bar_leading_icon.dart';
import 'package:ls_server_app/presentation/main_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = ScreenFormatHelper.isNarrow(constraints);

        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: StatusBarBackground(connected: state.isConnected),
          leading: Row(
            children: [
              SizedBox(width: 8),
              IconButton(
                onPressed: () { openSettings(); },
                icon: const Icon(LucideIcons.settings, color: Colors.white, size: 28)
              )
            ]
          ),
          title: _StatusBarTitle(
            profile: state.profile,
            isConnected: state.isConnected,
            isNarrow: isNarrow
          ),
          actions: [
            StatusBarConnectButton(
              connected: state.isConnected,
              onPressed: () {
                if (state.isConnected) { logOut(); }
              },
              isNarrow: isNarrow,
            )
          ],
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class _StatusBarTitle extends StatelessWidget {
  final SshProfile profile;
  final bool isConnected;
  final bool isNarrow;

  const _StatusBarTitle({
    super.key,
    required this.profile,
    required this.isConnected,
    required this.isNarrow
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isNarrow) ...[
          StatusBarLeadingIcon(connected: isConnected),
          Text(
            profile.isBlank()
                ? "Not connected"
                : profile.getIdentifier(),
            style: TextStyle(color: Colors.white),
          )
        ]
        else
          if (profile.isBlank()) Text(
            "Not connected",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          )
          else Column(
            children: [
              Text(
                "${profile.url}:${profile.port}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              Text(
                  profile.user,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
              )
            ],
          )
      ],
    );
  }

}