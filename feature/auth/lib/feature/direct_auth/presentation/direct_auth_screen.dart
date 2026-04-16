import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/global_error_warning.dart';
import 'package:ui/component/title_header.dart';

import '../../../presentation/component/password_text_form_field.dart';
import '../../../presentation/component/ssh_auth_fields.dart';
import '../../../presentation/component/ssh_connect_button.dart';
import 'direct_auth_event.dart';
import 'direct_auth_state.dart';

class DirectAuthScreen extends StatefulWidget {
  final DirectAuthState state;
  final Function(DirectAuthEvent) onEvent;

  const DirectAuthScreen({
    super.key,
    required this.state,
    required this.onEvent
  });

  @override
  State<StatefulWidget> createState() => _DirectAuthScreenState();

}

class _DirectAuthScreenState extends State<DirectAuthScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController sshController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [

        SshAuthFields(
          enabled: !widget.state.loading,
          userController: userController,
          urlController: urlController,
          portController: portController,
          sshController: sshController,
          disableLocalSshKey: true,
          loadSshFile: (path) => widget.onEvent(LoadSshFile(sshFilePath: path)),
          wrongFields: widget.state.wrongFields,
        ),

        PasswordTextFormField(
          controller: passwordController,
          enabled: widget.state.passwordRequired && !widget.state.loading
        ),

        const Spacer(),

        AnimatedGlobalErrorWarning(
            error: widget.state.globalError,
            onClose: () => widget.onEvent(ClearError())
        ),

        SshConnectButton(
          loading: widget.state.loading,
          onPressed: () {
            final event = Connect(
              user: userController.text,
              serverUrl: urlController.text,
              serverPort: portController.text,
              sshFilePath: sshController.text,
              password: widget.state.passwordRequired ? passwordController.text : null
            );
            widget.onEvent(event);
          },
        ),
      ],
    );
  }
}