import 'package:feature_ssh_key_manager/presentation/component/confirm_apply_dialog.dart';
import 'package:feature_ssh_key_manager/presentation/component/load_failure_view.dart';
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
  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  const SshKeyManagerScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.title,
    required this.onBack,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final showRemoteLoadingOverlay = state.remoteLoading || state.applying;
    final hasError = state.error.isNotEmpty;
    final hasPendingRemoteChanges = state.hasPendingRemoteChanges;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            if (state.authorizedKeysPath != null)
              Text(
                state.authorizedKeysPath!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: actions,
      ),
      // Nothing can be staged while a write is in flight or while there is no
      // snapshot to apply against.
      floatingActionButton: (state.applying || state.loadFailed)
          ? null
          : ExpandableFab(
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
      bottomNavigationBar: (!hasError && !hasPendingRemoteChanges)
          ? null
          : SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasError)
                    AnimatedGlobalErrorWarning(
                      error: state.error,
                      onClose: () => onEvent(DismissError()),
                    ),
                  if (hasPendingRemoteChanges)
                    PendingChangesBar(
                      pendingChangeCount: state.pendingChangeCount,
                      applying: state.applying,
                      canApply: state.canApplyRemoteChanges,
                      onApply: () => _confirmApply(context),
                      onDiscard: () => onEvent(DiscardRemoteChanges()),
                    ),
                ],
              ),
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: state.loadFailed
                ? LoadFailureView(
                    error: state.error,
                    onRetry: () => onEvent(ReloadRemoteKeys()),
                  )
                : RemoteKeysSection(
                    remoteKeys: state.remoteKeys,
                    stagedKeys: state.stagedKeys,
                    onToggleDeletion: (id) => onEvent(
                      ToggleRemoteKeyDeletion(id: id),
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

  void _confirmApply(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmApplyDialog(
          additions: state.stagedKeys,
          removals: state.keysMarkedForDeletion,
          wouldRemoveEveryKey: state.wouldRemoveEveryKey,
          authorizedKeysPath: state.authorizedKeysPath ?? '',
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            onEvent(ApplyRemoteChanges());
          },
        );
      },
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
