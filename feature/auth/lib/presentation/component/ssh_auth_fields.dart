import 'package:domain/model/ssh_connect_fields.dart';
import 'package:feature_auth/presentation/component/ssh_file_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../../util/profile_title_util.dart';

class SshAuthFields extends StatefulWidget {
  final bool enabled;
  final bool nameField;

  final TextEditingController? nameController;
  final TextEditingController userController;
  final TextEditingController urlController;
  final TextEditingController portController;
  final TextEditingController sshController;
  final Function(String) loadSshFile;

  final bool disableLocalSshKey;

  final List<SshConnectFields> wrongFields;

  const SshAuthFields({
    super.key,

    required this.enabled,

    this.nameField = false,
    this.nameController,

    required this.userController,
    required this.urlController,
    required this.portController,
    required this.sshController,
    required this.loadSshFile,

    required this.disableLocalSshKey,

    required this.wrongFields
  });

  @override
  State<StatefulWidget> createState() => SshAuthFieldsState();

}

class SshAuthFieldsState extends State<SshAuthFields> {

  late String profileTitle = getProfileTitle(
      user: widget.userController.text,
      url: widget.urlController.text,
      port: widget.portController.text
  );

  void updateProfileTitle() {
    setState(() {
      profileTitle = getProfileTitle(
        user: widget.userController.text,
        url: widget.urlController.text,
        port: widget.portController.text
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profileTitle,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),

        if (widget.nameField && (widget.nameController != null))
          TextFormField(
            enabled: widget.enabled,
            controller: widget.nameController,
            decoration: InputDecoration(
              labelText: 'Server Name (optional)',
              border: const OutlineInputBorder(),
            ),
          ),
        
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = ScreenFormatHelper.isNarrowWithThreshold(constraints, 400);

            return Column(
              children: [
                isNarrow
                    ? Column(
                  children: [
                    TextFormField(
                      enabled: widget.enabled,
                      controller: widget.urlController,
                      onChanged: (_) => updateProfileTitle(),
                      decoration: InputDecoration(
                        labelText: 'Server URL',
                        errorText: widget.wrongFields.contains(SshConnectFields.url) ? "Required" : null,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        enabled: widget.enabled,
                        controller: widget.portController,
                        onChanged: (_) => updateProfileTitle(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port',
                          counterText: '',
                          errorText: widget.wrongFields.contains(SshConnectFields.port) ? "Required" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: widget.enabled,
                        controller: widget.urlController,
                        onChanged: (_) => updateProfileTitle(),
                        decoration: InputDecoration(
                          labelText: 'Server URL',
                          errorText: widget.wrongFields.contains(SshConnectFields.url) ? "Required" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 96,
                      child: TextFormField(
                        enabled: widget.enabled,
                        controller: widget.portController,
                        onChanged: (_) => updateProfileTitle(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port',
                          counterText: '',
                          errorText: widget.wrongFields.contains(SshConnectFields.port) ? "Required" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                isNarrow
                    ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        enabled: widget.enabled,
                        controller: widget.userController,
                        onChanged: (_) => updateProfileTitle(),
                        decoration: InputDecoration(
                          labelText: 'User',
                          errorText: widget.wrongFields.contains(SshConnectFields.user) ? "Required" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SshFilePickerField(
                      enable: widget.enabled,
                      error: widget.wrongFields.contains(SshConnectFields.filePath),
                      noLocal: widget.disableLocalSshKey,
                      constraints: constraints,
                      controller: widget.sshController,
                      onFilePicked: (path) => widget.loadSshFile(path),
                    ),
                  ],
                )
                    : Row(
                  children: [
                    SizedBox(
                      width: 128,
                      child: TextFormField(
                        enabled: widget.enabled,
                        controller: widget.userController,
                        onChanged: (_) => updateProfileTitle(),
                        decoration: InputDecoration(
                          labelText: 'User',
                          errorText: widget.wrongFields.contains(SshConnectFields.user) ? "Required" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SshFilePickerField(
                        enable: widget.enabled,
                        error: widget.wrongFields.contains(SshConnectFields.filePath),
                        noLocal: widget.disableLocalSshKey,
                        constraints: constraints,
                        controller: widget.sshController,
                        onFilePicked: (path) => widget.loadSshFile(path),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        )

      ],
    );
  }

}