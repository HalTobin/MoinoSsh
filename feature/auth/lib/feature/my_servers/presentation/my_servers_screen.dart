import 'package:feature_auth/feature/my_servers/presentation/component/password_required_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/component/password_required_dialog.dart';
import 'package:ui/component/title_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';

import '../../../presentation/component/ssh_connect_button.dart';
import '../model/ConnectWithProfilePasswordMethod.dart';
import 'component/server_profile_item.dart';
import 'my_servers_event.dart';
import 'my_servers_state.dart';

class MyServersScreen extends StatefulWidget {
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
  State<StatefulWidget> createState() => _MyServersScreenState();

}

class _MyServersScreenState extends State<MyServersScreen> {
  final TextEditingController _sshPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          spacing: 16,
          children: [

            TitleHeader(
              icon: LucideIcons.server,
              title: "My Servers",
              trailingContent: TitleHeaderTrailingContent.action(
                title: "Add",
                icon: LucideIcons.plus,
                onPressed: () => widget.onAddEditServer(null)
              )
            ),

            Expanded(
              child: AnimatedCrossFade(
                firstChild: CircularProgressIndicator(),
                secondChild: AnimatedCrossFade(
                  crossFadeState: widget.state.servers.isEmpty ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstChild: _ServerList(
                    state: widget.state,
                    onEvent: widget.onEvent,
                    onAddEditServer: (profileId) {
                      widget.onAddEditServer(profileId);
                      widget.onEvent(EditionMode(serverProfileId: null));
                    }
                  ),
                  secondChild: EmptyList(
                    message: "No profile found",
                    onAction: () => widget.onAddEditServer(null)
                  ),
                ),
                crossFadeState: widget.state.loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300)
              )
            ),

            Column(
              children: [
                SshConnectButton(
                  loading: widget.state.connecting,
                  onPressed: widget.state.selectedServerId != null
                    ? () {
                      if (widget.state.sshPasswordRequired) {
                        if (widget.state.biometricsAvailable) {
                          final method = ConnectWithProfilePasswordMethod.biometrics();
                          final event = ConnectWithProfile(method: method);
                          widget.onEvent(event);
                        }
                        else {
                          openPasswordRequest(context, constraints);
                        }
                      }
                      else {
                        final method = ConnectWithProfilePasswordMethod.none();
                        final event = ConnectWithProfile(method: method);
                        widget.onEvent(event);
                      }
                    }
                  : null,
                ),

                PasswordRequiredIndicator(
                  enable: widget.state.sshPasswordRequired,
                )
              ],
            )
          ],
        );
      }
    );
  }

  void openPasswordRequest(
    BuildContext context,
    BoxConstraints constraints
  ) {
    autoModal(
      context: context,
      constraints: constraints,
      child: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: PasswordRequiredDialog(
          onPasswordEntered: (password) {
            Navigator.pop(context);
            final method = ConnectWithProfilePasswordMethod.password(password);
            final event = ConnectWithProfile(method: method);
            widget.onEvent(event);
          },
          onDismiss: () => Navigator.pop(context),
          onBiometricsRequest: widget.state.biometricsAvailable
            ? () {
              Navigator.pop(context);
              final method = ConnectWithProfilePasswordMethod.biometrics();
              final event = ConnectWithProfile(method: method);
              widget.onEvent(event);
            }
            : null
        )
      )
    );
  }

}

class _ServerList extends StatelessWidget {
  final MyServersState state;
  final Function(MyServersEvent) onEvent;
  final Function(int?) onAddEditServer;

  const _ServerList({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onAddEditServer
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        //padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),

        itemCount: state.servers.length,
        itemBuilder: (BuildContext context, int index) {
          final profile = state.servers[index];

          final MyServersEvent selectEvent = SelectServer(serverProfileId: profile.id);
          final MyServersEvent editEvent = EditionMode(serverProfileId: profile.id);

          return ServerProfileItem(
            profile: profile,
            selected: (state.selectedServerId == profile.id),
            onClick: () => onEvent(selectEvent),
            editionMode: (state.editionServerId == profile.id),
            onEditionMode: () => onEvent(editEvent),
            onEdit: () => onAddEditServer(profile.id)
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider()
      )
    );
  }

}