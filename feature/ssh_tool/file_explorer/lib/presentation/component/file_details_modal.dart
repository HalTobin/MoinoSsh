import 'package:feature_file_explorer/data/file_entry.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/title_header.dart';

import '../../util/size_helper.dart';

class FileDetailsModal extends StatelessWidget {
  final File file;
  final VoidCallback onDismiss;
  final VoidCallback? openFile;
  final String openLabel;
  final IconData openIcon;

  const FileDetailsModal({
    super.key,
    required this.file,
    required this.onDismiss,
    this.openFile,
    this.openLabel = "Open as text",
    this.openIcon = LucideIcons.fileText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        TitleHeader(
          icon: file.type.icon ?? LucideIcons.file,
          title: "File details",
          trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: onDismiss),
        ),
        const SizedBox(height: 16),

        _InfoRow(label: 'Name', value: file.name),
        _InfoRow(label: 'Path', value: file.path),
        _InfoRow(label: 'Size', value: SizeHelper.formatSize(file.size)),
        _InfoRow(label: 'Type', value: file.type.name),
        if (file.isHidden)
          const _InfoRow(label: 'Status', value: 'Hidden File'),

        const SizedBox(height: 24),

        if (openFile != null)
          ElevatedButton.icon(
            onPressed: openFile,
            icon: Icon(openIcon),
            label: Text(openLabel),
          )
        else
          const ElevatedButton(
            onPressed: null,
            child: Text("Can't open this file"),
          ),
      ],
    );
  }

}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
