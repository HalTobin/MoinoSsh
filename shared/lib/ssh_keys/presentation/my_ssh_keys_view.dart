import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared/ssh_keys/model/my_ssh_keys_select_mode.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/empty_list.dart';
import 'package:ui/component/expandable_fab.dart';
import 'package:ui/component/password_required_dialog.dart';
import 'package:util/ssh/ssh_key_details.dart';

import 'component/generate_key_dialog.dart';
import 'component/ssh_key_item.dart';
import 'my_ssh_keys_event.dart';
import 'my_ssh_keys_state.dart';

class MySshKeysView extends StatelessWidget {
  final MySshKeysState state;
  final Function(MySshKeysEvent) onEvent;
  final Future<SshKeyDetails> Function(String keyPath, {String? password, String? comment}) onLoadPublicKey;

  final MySshKeysSelectMode? selectMode;
  final void Function(String value)? onSelect;
  final Function() onDismiss;
  final bool embedded;

  const MySshKeysView({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onLoadPublicKey,
    required this.selectMode,
    required this.onSelect,
    required this.onDismiss,
    this.embedded = false,
  });

  bool get _selectionEnable => selectMode != null && onSelect != null;

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                        message: "No SSH keys found",
                        onAction: null,
                      ),
              ),
              if (_selectionEnable)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Center(
                      child: SizedBox(
                        width: 180,
                        child: AppButton(
                          onClick: () => _confirmSelection(context),
                          icon: LucideIcons.key,
                          text: "SELECT",
                          enabled: state.selectedKeyPath != null,
                          stretch: true,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (state.loading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Future<void> _confirmSelection(BuildContext context) async {
    final selectedPath = state.selectedKeyPath;
    final mode = selectMode;
    final select = onSelect;
    if (selectedPath == null || mode == null || select == null) {
      return;
    }

    switch (mode) {
      case MySshKeysSelectMode.privateKeyPath:
        select(selectedPath);
      case MySshKeysSelectMode.publicKeyLine:
        final publicKeyLine = await _resolvePublicKeyLine(context, selectedPath);
        if (publicKeyLine != null) {
          select(publicKeyLine);
        }
    }
  }

  Future<String?> _resolvePublicKeyLine(
    BuildContext context,
    String keyPath,
  ) async {
    final comment = state.keys
        .where((key) => key.path == keyPath)
        .map((key) => key.name)
        .firstOrNull;

    Future<SshKeyDetails> load([String? password]) {
      return onLoadPublicKey(
        keyPath,
        password: password,
        comment: comment,
      );
    }

    try {
      final details = await load();
      return details.publicKeyLine;
    } on SshKeyDetailsLoadException catch (error) {
      if (!error.passwordRequired) {
        if (context.mounted) {
          _showErrorSnackBar(context, error.message);
        }
        return null;
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Could not read public key');
      }
      return null;
    }

    if (!context.mounted) {
      return null;
    }

    final password = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AppDialogLayout(
          child: PasswordRequiredDialog(
            confirmText: 'UNLOCK',
            onDismiss: () => Navigator.of(dialogContext).pop(),
            onPasswordEntered: (password, _) {
              Navigator.of(dialogContext).pop(password);
            },
          ),
        );
      },
    );

    if (password == null || !context.mounted) {
      return null;
    }

    try {
      final details = await load(password);
      return details.publicKeyLine;
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Could not unlock public key');
      }
      return null;
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onGenerate: (name, password, algorithm) {
            Navigator.of(dialogContext).pop();
            onEvent(GenerateKey(
              name: name,
              password: password,
              algorithm: algorithm,
            ));
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
