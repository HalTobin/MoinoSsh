import 'package:feature_file_explorer/feature/file_content/presentation/file_content_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FileContentScreen extends StatelessWidget {
  final FileContentState state;

  const FileContentScreen({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: _FileContentTitle(fileName: state.fileName, filePath: state.filePath)
      ),
      body: Text(state.content ?? ""),
    );
  }

}

class _FileContentTitle extends StatelessWidget {
  final String fileName;
  final String filePath;

  const _FileContentTitle({
    required this.fileName,
    required this.filePath
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          fileName,
          style: textTheme.titleMedium
        ),
        Text(
          filePath,
          style: textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

}