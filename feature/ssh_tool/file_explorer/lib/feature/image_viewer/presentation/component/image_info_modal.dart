import 'package:domain/model/image_file.dart';
import 'package:feature_file_explorer/feature/image_viewer/model/image_metadata.dart';
import 'package:feature_file_explorer/util/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/title_header.dart';

class ImageInfoModal extends StatelessWidget {
  final ImageFile file;
  final ImageMetadata? metadata;
  final VoidCallback onDismiss;

  const ImageInfoModal({
    super.key,
    required this.file,
    required this.metadata,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        TitleHeader(
          icon: LucideIcons.info,
          title: "Image details",
          trailingContent: TitleHeaderTrailingContent.dismissable(onDismiss: onDismiss),
        ),
        const SizedBox(height: 8),
        _InfoRow(label: "Name", value: file.name),
        _InfoRow(label: "Path", value: file.path),
        _InfoRow(label: "Size", value: SizeHelper.formatSize(file.size)),
        _InfoRow(
          label: "Modified",
          value: file.lastModified != null
              ? _formatDateTime(file.lastModified!)
              : "Unknown",
        ),
        _InfoRow(
          label: "Resolution",
          value: metadata?.resolution ?? "Unknown",
        ),
        _InfoRow(
          label: "Captured",
          value: metadata?.captureTime != null
              ? _formatDateTime(metadata!.captureTime!)
              : "Unknown",
        ),
        _InfoRow(
          label: "Location",
          value: metadata?.location ?? "Unknown",
        ),
        _InfoRow(
          label: "Color space",
          value: metadata?.colorSpace ?? "Unknown",
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final s = local.second.toString().padLeft(2, '0');
    return "$y-$m-$d $h:$min:$s";
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
