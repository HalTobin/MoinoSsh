import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum SshTool {
    systemd(
        identifier: "systemd",
        title: "SystemD",
        icon: LucideIcons.monitorPlay
    ),
    fileExplorer(
        identifier: "file_manager",
        title: "File Explorer",
        icon: LucideIcons.folder
    );

    const SshTool({
        required this.identifier,
        required this.title,
        required this.icon
    });

    final String identifier;
    final String title;
    final IconData icon;
}