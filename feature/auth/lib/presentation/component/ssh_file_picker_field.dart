import 'package:provider/provider.dart';
import 'package:feature_auth/feature/my_ssh_keys/di/my_ssh_keys_provider.dart';
import 'package:feature_auth/feature/my_ssh_keys/presentation/my_ssh_keys_view.dart';
import 'package:feature_auth/feature/my_ssh_keys/presentation/my_ssh_keys_view_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

class SshFilePickerField extends StatelessWidget {
  final bool enable;
  final bool error;
  final bool noLocal;
  final BoxConstraints constraints;
  final TextEditingController controller;
  final void Function(String path) onFilePicked;

  const SshFilePickerField({
    super.key,
    required this.enable,
    required this.error,
    required this.noLocal,
    required this.constraints,
    required this.controller,
    required this.onFilePicked,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async => _pickSshKey(context, constraints),
      decoration: InputDecoration(
        labelText: 'SSH File Path',
        errorText: error ? "Select a valid SSH key" : null,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(LucideIcons.folderKey),
          onPressed: () async => _pickSshKey(context, constraints),
        ),
      ),
    );
  }

  Future<void> _pickSshKey(
    BuildContext context,
    BoxConstraints constraints,
  ) async {
    if (enable) {
      if (noLocal) {
        FilePickerResult? result = await FilePicker.pickFiles();
        if (result != null && result.files.single.path != null) {
          final String sshFile = result.files.single.path!;
          _select(sshFile);
        }
      } else {
        _showMySshKeyMenu(context, constraints);
      }
    }
  }

  Future<void> _showMySshKeyMenu(
    BuildContext context,
    BoxConstraints constraints,
  ) async {
    final bool isShrink = ScreenFormatHelper.isNarrow(constraints);
    autoModal(
      context: context,
      constraints: constraints,
      child: MySshKeysProvider(
        child: Consumer<MySshKeysViewModel>(
          builder: (context, viewmodel, child) {
            return MySshKeysView(
              state: viewmodel.state,
              onEvent: viewmodel.onEvent,
              isShrink: isShrink,
              selectionEnable: true,
              onSelect: (String? keyPath) {
                _select(keyPath ?? "");
                Navigator.pop(context);
              },
              onDismiss: () => Navigator.pop(context),
            );
          }
        )
      )
    );
  }

  void _select(String path) {
    controller.text = path;
    onFilePicked(path);
  }

}