import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/screen_format/screen_format_helper.dart';
import 'package:util/ssh/ssh_key_details.dart';

import 'component/generate_key_dialog.dart';
import 'component/ssh_key_item.dart';
import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysView extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final Future<SshKeyDetails> Function(String keyPath, {String? password, String? comment}) onLoadPublicKey;

  final Function(String?)? onSelect;
  final Function() onDismiss;
  final bool embedded;
  final bool stagePublicKeyForRemote;

  const MySshKeysView({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onLoadPublicKey,
    required this.onSelect,
    required this.onDismiss,
    this.embedded = false,
    this.stagePublicKeyForRemote = false,
  });

  bool get _selectionEnable => onSelect != null;

  @override
  Widget build(BuildContext context) {
    if (embedded) {
      return SizedBox.expand(
        child: _buildBody(horizontalPadding: 0),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: onDismiss, icon: const Icon(LucideIcons.arrowLeft)),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Icon(LucideIcons.folderKey),
            Text("My SSH keys"),
          ],
        )
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody({double horizontalPadding = 16}) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = ScreenFormatHelper.isNarrow(constraints);

          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: state.keys.isNotEmpty
                        ? _KeyList(
                          state: state,
                          onEvent: onEvent,
                          selectionEnable: _selectionEnable,
                          onLoadPublicKey: onLoadPublicKey,
                        ) : EmptyList(message: "No profile found", onAction: null)
                    ),

                    _ModalBottomActions(
                        state: state,
                        onEvent: onEvent,
                        isShrink: isNarrow,
                        onKeySelect: onSelect,
                        stagePublicKeyForRemote: stagePublicKeyForRemote,
                    ),

                    SizedBox(height: 8)
                  ],
                ),
              ),
              if (state.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
    );
  }
}

class _KeyList extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool selectionEnable;
  final Future<SshKeyDetails> Function(String keyPath, {String? password, String? comment}) onLoadPublicKey;

  const _KeyList({
    required this.state,
    required this.onEvent,
    required this.selectionEnable,
    required this.onLoadPublicKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final key = state.keys[index];

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 4),
              child: SshKeyItem(
                sshKeyFile: key,
                selectionEnable: selectionEnable,
                selected: selectionEnable && state.selectedKeyPath == key.path,
                onClick: selectionEnable
                    ? () => onEvent(SelectKey(keyPath: key.path))
                    : null,
                onEdit: (newName) {
                  onEvent(RenameKey(keyPath: key.path, newName: newName));
                },
                onDelete: () => onEvent(DeleteKey(keyPath: key.path)),
                onLoadPublicKey: (password) => onLoadPublicKey(
                  key.path,
                  password: password,
                  comment: key.name,
                ),
              )
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
    );
  }

}

class _ModalBottomActions extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final bool isShrink;
  final bool stagePublicKeyForRemote;

  final Function(String?)? onKeySelect;

  const _ModalBottomActions({
    required this.state,
    required this.onEvent,
    required this.isShrink,
    required this.onKeySelect,
    required this.stagePublicKeyForRemote,
  });

  void _showGenerateKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return GenerateKeyDialog(
          description: stagePublicKeyForRemote
              ? 'A new Ed25519 key pair will be generated. The private key is saved to local storage immediately. The public key is staged for the remote whitelist until you apply.'
              : 'A new Ed25519 key pair will be generated. The private key is saved to local storage.',
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onGenerate: (name, password) {
            Navigator.of(dialogContext).pop();
            onEvent(GenerateKey(name: name, password: password));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget wrapButton(Widget button) {
      if (isShrink) {
        return Expanded(child: button);
      } else {
        return SizedBox(width: 180, child: button);
      }
    }

    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        wrapButton(
          AppButton(
            onClick: () => _showGenerateKeyDialog(context),
            icon: LucideIcons.bookKey,
            text: "GENERATE",
            stretch: true,
          )
        ),
        wrapButton(
          AppButton(
            onClick: () async {
              FilePickerResult? result = await FilePicker.pickFiles();
              if (result != null && result.files.single.path != null) {
                final String sshFile = result.files.single.path!;
                final event = AddKey(keyPath: sshFile);
                onEvent(event);
              }
            },
            icon: LucideIcons.plus,
            text: "ADD",
            stretch: true
          )
        ),
        if (onKeySelect != null)
          wrapButton(
            AppButton(
              onClick: () => onKeySelect?.call(state.selectedKeyPath),
              icon: LucideIcons.key,
              text: "SELECT",
              enabled: state.selectedKeyPath != null,
              stretch: true
            )
          )
      ],
    );
  }

}
