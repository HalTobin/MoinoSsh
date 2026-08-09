import 'package:feature_ssh_key_manager/presentation/component/paste_public_key_dialog.dart';
import 'package:feature_ssh_key_manager/presentation/component/pending_changes_bar.dart';
import 'package:feature_ssh_key_manager/presentation/component/remote_keys_section.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_event.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared/ssh_keys/di/my_ssh_keys_provider.dart';
import 'package:shared/ssh_keys/model/my_ssh_keys_select_mode.dart';
import 'package:ui/component/expandable_fab.dart';
import 'package:ui/component/global_error_warning.dart';

class SshKeyManagerScreen extends StatelessWidget {
  final SshKeyManagerState state;
  final Function(SshKeyManagerEvent) onEvent;

  const SshKeyManagerScreen({
    super.key,
    required this.state,
    required this.onEvent,
  });

  @override
  Widget build(BuildContext context) {
    final showRemoteLoadingOverlay = state.remoteLoading || state.applying;

    return Scaffold(
      floatingActionButton: ExpandableFab(
        heroTagPrefix: 'ssh_key_manager',
        label: 'Add',
        actions: const [
          ExpandableFabAction(
            id: 'from_my_keys',
            label: 'From my keys',
            icon: LucideIcons.folderKey,
          ),
          ExpandableFabAction(
            id: 'manual',
            label: 'Paste public key',
            icon: LucideIcons.clipboardPaste,
          ),
        ],
        onAction: (action) => _handleFabAction(context, action),
      ),
      bottomNavigationBar: state.hasPendingRemoteChanges
          ? PendingChangesBar(
              pendingChangeCount: state.pendingChangeCount,
              applying: state.applying,
              onApply: () => onEvent(ApplyRemoteChanges()),
              onDiscard: () => onEvent(DiscardRemoteChanges()),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RemoteKeysSection(
                    remoteKeys: state.remoteKeys,
                    stagedPublicKeyLines: state.stagedPublicKeyLines,
                    onToggleDeletion: (line) => onEvent(
                      ToggleRemoteKeyDeletion(line: line),
                    ),
                  ),
                ),
                if (showRemoteLoadingOverlay)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedGlobalErrorWarning(
            error: state.error,
            onClose: () => onEvent(DismissError()),
          ),
        ],
      ),
    );
  }

  Future<void> _handleFabAction(
    BuildContext context,
    ExpandableFabAction action,
  ) async {
    switch (action.id) {
      case 'from_my_keys':
        _openMyKeysPicker(context);
      case 'manual':
        _showPastePublicKeyDialog(context);
    }
  }

  void _openMyKeysPicker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => MySshKeysProvider(
          selectMode: MySshKeysSelectMode.publicKeyLine,
          onSelect: (publicKeyLine) {
            onEvent(StagePublicKey(publicKeyLine: publicKeyLine));
            Navigator.of(routeContext).pop();
          },
        ),
      ),
    );
  }

  void _showPastePublicKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return PastePublicKeyDialog(
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onConfirm: (publicKeyLine) {
            Navigator.of(dialogContext).pop();
            onEvent(StagePublicKey(publicKeyLine: publicKeyLine));
          },
        );
      },
    );
  }
}
