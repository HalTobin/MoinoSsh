import 'package:flutter/material.dart';

class FileContentTitle extends StatelessWidget {
  final String fileName;
  final String filePath;
  final bool modified;

  const FileContentTitle({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.modified
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          modified ? "$fileName*" : fileName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: modified ? FontWeight.bold : FontWeight.normal,
            fontStyle: modified ? FontStyle.italic : FontStyle.normal
          ),
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