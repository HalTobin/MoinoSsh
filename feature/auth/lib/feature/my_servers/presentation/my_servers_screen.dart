import 'package:feature_auth/feature/my_servers/presentation/component/server_profile_item.dart';
import 'package:flutter/material.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/component/password_required_dialog.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../model/connect_with_profile_password_method.dart';
import '../model/server_profile_ui.dart';
import 'my_servers_event.dart';
import 'my_servers_state.dart';

class MyServersScreen extends StatelessWidget {
  final MyServersState state;
  final Function(MyServersEvent) onEvent;
  final Function(int?) onAddEditServer;

  const MyServersScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onAddEditServer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => onAddEditServer(null),
        icon: const Icon(LucideIcons.plus),
        label: const Text("Add a server"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            spacing: 16,
            children: [
              Expanded(
                child: AnimatedCrossFade(
                  firstChild: CircularProgressIndicator(),
                  secondChild: state.servers.isNotEmpty
                    ? _ServerList(
                      state: state,
                      onConnect: (profile) => _connect(context: context, profile: profile),
                      onAddEditServer: (profile) => onAddEditServer(profile.id)
                    )
                    : EmptyList(
                      message: "No profile found",
                      onAction: () => onAddEditServer(null)
                    ),
                  crossFadeState: state.loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300)
                )
              ),
            ],
          );
        }
      ),
    );
  }

  void _openPasswordRequest({
    required BuildContext context,
    required ServerProfileUi profile
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AppDialogLayout(
          child: PasswordRequiredDialog(
            onPasswordEntered: (password, save) {
              Navigator.pop(context);
              final method = ConnectWithProfilePasswordMethod.password(password, save);
              final event = ConnectWithProfile(profile: profile, method: method);
              onEvent(event);
            },
            onDismiss: () => Navigator.pop(context),
            biometricsAvailable: state.biometricsAvailable,
            onBiometricsRequest: (profile.securedSshKeyPassword != null) ? () {
              Navigator.pop(context);
              final method = ConnectWithProfilePasswordMethod.biometrics();
              final event = ConnectWithProfile(profile: profile, method: method);
              onEvent(event);
            } : null
          )
        );
      }
    );
  }

  void _connect({
    required BuildContext context,
    required ServerProfileUi profile
  }) {
    if (profile.keyRequiresPassword) {
      _openPasswordRequest(context: context, profile: profile);
    }
    else {
      final method = ConnectWithProfilePasswordMethod.none();
      final event = ConnectWithProfile(profile: profile, method: method);
      onEvent(event);
    }
  }

}

class _ServerList extends StatelessWidget {
  final MyServersState state;
  final Function(ServerProfileUi) onConnect;
  final Function(ServerProfileUi) onAddEditServer;

  const _ServerList({
    super.key,
    required this.state,
    required this.onConnect,
    required this.onAddEditServer
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),

        itemCount: state.servers.length,
        itemBuilder: (BuildContext context, int index) {
          final profile = state.servers[index];

          return ServerProfileItem(
            profile: profile,
            onConnect: () => onConnect(profile),
            onEdit: () => onAddEditServer(profile)
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider()
      )
    );
  }

}