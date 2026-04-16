import 'package:flutter/material.dart';
import 'package:ui/component/app_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../presentation/component/ssh_auth_fields.dart';
import 'add_edit_server_event.dart';
import 'add_edit_server_state.dart';
import 'add_edit_server_viewmodel.dart';

class AddEditServerView extends StatefulWidget {
  final int? serverProfileId;
  final AddEditServerState state;
  final Function(AddEditServerEvent) onEvent;
  final Stream<AddEditServerUiEvent> uiEvent;
  final Function() onDismiss;

  const AddEditServerView({
    super.key,
    this.serverProfileId,
    required this.state,
    required this.onEvent,
    required this.uiEvent,
    required this.onDismiss
  });

  @override
  State<StatefulWidget> createState() => AddEditServerViewState();

}

class AddEditServerViewState extends State<AddEditServerView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController sshController = TextEditingController();

  late bool isNewServer = widget.serverProfileId == null;

  @override void initState() {
    super.initState();

    if (widget.serverProfileId != null) {
      final event = LoadServerProfile(serverProfileId: widget.serverProfileId!);
      widget.onEvent(event);
    }

    widget.uiEvent.listen((event) {
      switch (event) {
        case UpdateFields(): {
          nameController.text = event.name ?? "";
          urlController.text = event.url;
          portController.text = event.port;
          userController.text = event.user;
          sshController.text = event.sshFilePath;
        }
        case ExitView(): {
          widget.onDismiss();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          isNewServer ? LucideIcons.grid2x2Plus : LucideIcons.pen,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(isNewServer ? "New server" : "Edit a server"),
        actions: [
          IconButton(
            onPressed: widget.onDismiss,
            icon: Icon(LucideIcons.x)
          )
        ],
        surfaceTintColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            SshAuthFields(
              enabled: true,
              nameField: true,
              nameController: nameController,
              userController: userController,
              urlController: urlController,
              portController: portController,
              sshController: sshController,
              disableLocalSshKey: false,
              loadSshFile: (path) => {},
              wrongFields: [],
            ),

            const Spacer(),

            AppButton(
                onClick: () {
                  final AddEditServerEvent event = SaveEditServer(
                    serverProfileId: widget.serverProfileId,
                    name: nameController.text,
                    user: userController.text,
                    url: urlController.text,
                    port: portController.text,
                    sshFilePath: sshController.text,
                  );
                  widget.onEvent(event);
                },
                icon: LucideIcons.save,
                text: "SAVE"
            )
          ],
        )
      )
    );
  }

}