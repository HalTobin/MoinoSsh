import 'package:feature_ssh_key_manager/presentation/component/generate_key_dialog.dart';
import 'package:feature_ssh_key_manager/presentation/component/pending_changes_bar.dart';
import 'package:feature_ssh_key_manager/presentation/component/remote_keys_section.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_event.dart';
import 'package:feature_ssh_key_manager/presentation/ssh_key_manager_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared/ssh_keys/di/my_ssh_keys_provider.dart';
import 'package:ui/component/global_error_warning.dart';
import 'package:ui/component/moino_tab.dart';

class SshKeyManagerScreen extends StatefulWidget {
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
  State<SshKeyManagerScreen> createState() => _SshKeyManagerScreenState();
}

class _SshKeyManagerScreenState extends State<SshKeyManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.state.selectedTab,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(SshKeyManagerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.selectedTab != _tabController.index) {
      _tabController.index = widget.state.selectedTab;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    if (_tabController.index != widget.state.selectedTab) {
      widget.onEvent(SwitchTab(tabIndex: _tabController.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final showRemoteLoadingOverlay =
        widget.state.selectedTab == 1 && (widget.state.remoteLoading || widget.state.applying);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            MoinoTab(
              icon: LucideIcons.folderKey,
              title: 'Local',
            ),
            MoinoTab(
              icon: LucideIcons.server,
              title: 'Remote',
            ),
          ],
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SizedBox.expand(
                      child: MySshKeysProvider(
                        key: ValueKey(widget.state.localKeysRefreshToken),
                        onKeySelect: null,
                        embedded: true,
                      ),
                    ),
                    RemoteKeysSection(
                      remoteKeys: widget.state.remoteKeys,
                      stagedPublicKeyLines: widget.state.stagedPublicKeyLines,
                      onToggleDeletion: (line) =>
                          widget.onEvent(ToggleRemoteKeyDeletion(line: line)),
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
          error: widget.state.error,
          onClose: () => widget.onEvent(DismissError()),
        ),
        if (widget.state.selectedTab == 1 && widget.state.hasPendingRemoteChanges)
          PendingChangesBar(
            pendingChangeCount: widget.state.pendingChangeCount,
            applying: widget.state.applying,
            onApply: () => widget.onEvent(ApplyRemoteChanges()),
            onDiscard: () => widget.onEvent(DiscardRemoteChanges()),
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
            widget.onEvent(GenerateKeyPair(name: name));
          },
        );
      },
    );
  }
}
