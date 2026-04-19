import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../feature/my_servers/di/my_servers_provider.dart';
import '../../feature/my_servers/presentation/my_servers_screen.dart';
import '../../feature/my_servers/presentation/my_servers_view_model.dart';
import 'auth_tab_layout.dart';

class MyServersTab extends StatelessWidget {
  final Function(int?) onAddEditServer;

  const MyServersTab({
    super.key,
    required this.onAddEditServer
  });

  @override
  Widget build(BuildContext context) {
    return MyServersProvider(
      child: Consumer<MyServersViewModel>(
        builder: (context, viewmodel, child) {
          return AuthTabLayout(
            child: MyServersScreen(
              state: viewmodel.state,
              onEvent: viewmodel.onEvent,
              onAddEditServer: onAddEditServer,
            )
          );
        }
      )
    );
  }
}