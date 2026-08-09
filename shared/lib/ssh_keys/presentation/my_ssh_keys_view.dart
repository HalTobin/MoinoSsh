import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/component/expandable_fab.dart';
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
    return Scaffold(
      appBar: embedded
          ? null
          : AppBar(
              leading: IconButton(
                onPressed: onDismiss,
                icon: const Icon(LucideIcons.arrowLeft),
              ),
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Icon(LucideIcons.folderKey),
                  Text("My SSH keys"),
                ],
              ),
            ),
      floatingActionButton: ExpandableFab(
        heroTagPrefix: 'ssh_keys',
        label: 'Add',
        actions: const [
          ExpandableFabAction(
            id: 'generate',
            label: 'Generate',
            icon: LucideIcons.bookKey,
          ),
          ExpandableFabAction(
            id: 'import',
            label: 'Import key',
            icon: LucideIcons.filePlus,
          ),
        ],
        onAction: (action) => _handleFabAction(context, action),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: embedded ? 0 : 16),
          child: Column(
            children: [
              Expanded(
                child: state.keys.isNotEmpty
                    ? _KeyList(
                        state: state,
                        onEvent: onEvent,
                        selectionEnable: _selectionEnable,
                        onLoadPublicKey: onLoadPublicKey,
                      )
                    : const EmptyList(
                        message: "No profile found",
                        onAction: null,
                      ),
              ),
              if (onSelect != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: SizedBox(
                      width: 180,
                      child: AppButton(
                        onClick: () => onSelect?.call(state.selectedKeyPath),
                        icon: LucideIcons.key,
                        text: "SELECT",
                        enabled: state.selectedKeyPath != null,
                        stretch: true,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (state.loading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Future<void> _handleFabAction(
    BuildContext context,
    ExpandableFabAction action,
  ) async {
    switch (action.id) {
      case 'generate':
        _showGenerateKeyDialog(context);
      case 'import':
        final FilePickerResult? result = await FilePicker.pickFiles();
        if (result != null && result.files.single.path != null) {
          onEvent(AddKey(keyPath: result.files.single.path!));
        }
    }
  }

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
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 88),
      itemCount: state.keys.length,
      itemBuilder: (BuildContext context, int index) {
        final key = state.keys[index];

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
    );
  }
}
