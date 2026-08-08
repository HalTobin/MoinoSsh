import 'package:feature_ssh_key_manager/presentation/component/generate_key_dialog.dart';
import 'package:feature_ssh_key_manager/presentation/component/pending_changes_bar.dart';
import 'package:feature_ssh_key_manager/presentation/component/remote_keys_section.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_event.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared/ssh_keys/di/my_ssh_keys_provider.dart';
import 'package:ui/component/global_error_warning.dart';

class SshKeyManagerScreen extends StatelessWidget {
  final SshKeyManagerState state;
  final Function(SshKeyManagerEvent) onEvent;
  final bool isNarrow;

  const SshKeyManagerScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final showRemoteLoadingOverlay =
        state.selectedTab == 1 && (state.remoteLoading || state.applying);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                icon: Icon(LucideIcons.folderKey),
                label: Text('Local'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(LucideIcons.server),
                label: Text('Remote'),
              ),
            ],
            selected: {state.selectedTab},
            onSelectionChanged: (selection) => onEvent(SwitchTab(tabIndex: selection.first)),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IndexedStack(
                  index: state.selectedTab,
                  sizing: StackFit.expand,
                  children: [
                    SizedBox.expand(
                      child: MySshKeysProvider(
                        key: ValueKey(state.localKeysRefreshToken),
                        onKeySelect: null,
                        embedded: true,
                      ),
                    ),
                    RemoteKeysSection(
                      remoteKeys: state.remoteKeys,
                      stagedPublicKeyLines: state.stagedPublicKeyLines,
                      onToggleDeletion: (line) => onEvent(ToggleRemoteKeyDeletion(line: line)),
                      onGenerateKey: () => _showGenerateKeyDialog(context),
                    ),
                  ],
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
        if (state.selectedTab == 1 && state.hasPendingRemoteChanges)
          PendingChangesBar(
            pendingChangeCount: state.pendingChangeCount,
            applying: state.applying,
            onApply: () => onEvent(ApplyRemoteChanges()),
            onDiscard: () => onEvent(DiscardRemoteChanges()),
          ),
      ],
    );
  }

  void _showGenerateKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return GenerateKeyDialog(
          onDismiss: () => Navigator.of(dialogContext).pop(),
          onGenerate: (name) {
            Navigator.of(dialogContext).pop();
            onEvent(GenerateKeyPair(name: name));
          },
        );
      },
    );
  }
}
