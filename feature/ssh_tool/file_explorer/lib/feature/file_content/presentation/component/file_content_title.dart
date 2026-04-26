import 'package:flutter/material.dart';

class FileContentTitle extends StatelessWidget {
  final String fileName;
  final String filePath;

  const FileContentTitle({
    super.key,
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