import 'package:feature_file_explorer/di/file_explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:feature_systemd_services/di/service_manager_provider.dart';
import '../data/ssh_tool.dart';

class ToolScreen extends StatelessWidget {
  final SshTool tool;
  final Function() onExit;

  const ToolScreen({
    super.key,
    required this.tool,
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
        title: Text(tool.title)
      ),
      body: switch (tool) {
        SshTool.systemd => const ServiceManagerProvider(),
        SshTool.fileExplorer => const FileExplorerProvider()
      }
    );
  }

}