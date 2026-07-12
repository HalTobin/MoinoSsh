import 'package:feature_auth/presentation/tabs/direct_auth_tab.dart';
import 'package:feature_auth/presentation/tabs/my_servers_tab.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';
import 'package:ui/navigation/push_animation.dart';

import '../feature/add_edit_server/di/add_edit_server_provider.dart';
import 'component/auth_screen_tab.dart';

class AuthScreen extends StatelessWidget {

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar.secondary(
              tabs: const [
                AuthScreenTab(
                  title: "My Servers",
                  icon: LucideIcons.server
                ),
                AuthScreenTab(
                  title: "Direct",
                  icon: LucideIcons.monitorUp
                )
              ],
            ),
            body: TabBarView(
              children: [
                MyServersTab(
                  onAddEditServer: (serverProfileId) =>
                    _navigateToAddEditServer(
                      context: context,
                      serverProfileId: serverProfileId
                    )
                ),
                DirectAuthTab()
              ]
            )
          )
        );
      }
    );
  }

  Future<void> _navigateToAddEditServer({
    required BuildContext context,
    int? serverProfileId
  }) async {
    Navigator.of(context).push(
      routeFromBottom(
        Material(
          child: AddEditServerProvider(
            serverProfileId: serverProfileId,
            onDismiss: () => Navigator.pop(context)
          )
        )
      )
    );
  }

}