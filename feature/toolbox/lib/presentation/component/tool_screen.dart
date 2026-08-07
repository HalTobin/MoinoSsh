import 'package:feature_download_tracker/di/download_tracker_provider.dart';
import 'package:feature_file_explorer/di/file_explorer_provider.dart';
import 'package:feature_ssh_key_manager/di/ssh_key_manager_provider.dart';
import 'package:feature_toolbox/presentation/toolbox_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:feature_systemd_services/di/service_manager_provider.dart';
import 'package:ui/navigation/navigation_type.dart';
import '../../data/ssh_tool.dart';
import '../../use_case/watch_pending_download_use_case.dart';

class ToolScreen extends StatelessWidget {
  final SshTool tool;
  final ToolboxState state;
  final Function() onExit;

  const ToolScreen({
    super.key,
    required this.tool,
    required this.state,
    required this.onExit
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: onExit,
          icon: const Icon(LucideIcons.arrowLeft)
        ),
        title: Text(tool.title),
        actions: _buildDownloadAction(context),
      ),
      body: switch (tool) {
        SshTool.systemd => const ServiceManagerProvider(),
        SshTool.fileExplorer => const FileExplorerProvider(),
        SshTool.downloadTracker => const DownloadTrackerProvider(
          navigationType: NavigationType.horizontal,
        ),
        SshTool.sshKeyManager => const SshKeyManagerProvider(),
      }
    );
  }

  List<Widget> _buildDownloadAction(BuildContext context) {
    if (tool == SshTool.downloadTracker || state.downloadStatus == DownloadStatus.none) {
      return const [];
    }

    final IconData iconData = switch (state.downloadStatus) {
      DownloadStatus.failed => LucideIcons.circleAlert,
      DownloadStatus.complete => LucideIcons.circleCheck,
      DownloadStatus.ongoing => LucideIcons.arrowDownToLine,
      DownloadStatus.none => LucideIcons.arrowDownToLine,
    };

    final Color? badgeColor = switch (state.downloadStatus) {
      DownloadStatus.failed => Theme.of(context).colorScheme.error,
      DownloadStatus.complete => Colors.green,
      DownloadStatus.ongoing => Theme.of(context).colorScheme.primary,
      DownloadStatus.none => null,
    };

    return [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Badge(
          backgroundColor: badgeColor,
          label: switch (state.downloadStatus) {
            DownloadStatus.failed => const Text('!', style: TextStyle(fontWeight: FontWeight.bold)),
            DownloadStatus.complete => const Icon(LucideIcons.check, size: 10, color: Colors.white),
            _ => null,
          },
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const DownloadTrackerProvider(
                    navigationType: NavigationType.vertical,
                  ),
                ),
              );
            },
            icon: Icon(iconData),
            tooltip: 'View Downloads',
          ),
        ),
      ),
    ];
  }

}