import 'package:domain/model/sftp/download_item.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DownloadEntryItem extends StatelessWidget {
  final DownloadItem item;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onShowFile;

  const DownloadEntryItem({
    super.key,
    required this.item,
    required this.onCancel,
    required this.onRetry,
    required this.onShowFile,
  });

  @override
  Widget build(BuildContext context) {
    final state = item.state;

    final IconData originIcon = item.origin == DownloadOrigin.local
        ? LucideIcons.uploadCloud
        : LucideIcons.downloadCloud;

    double progressValue = 0.0;
    String statusText = '';
    Widget? trailingAction;

    switch (state) {
      case Downloading():
        progressValue = state.progress;
        statusText = '${(state.progress * 100).toStringAsFixed(1)}%';
        trailingAction = IconButton(
          icon: const Icon(LucideIcons.x, color: Colors.grey),
          onPressed: onCancel,
          tooltip: 'Cancel Transfer',
        );
        break;
      case DownloadCompleted():
        progressValue = 1.0;
        statusText = 'Completed';
        trailingAction = IconButton(
          icon: Icon(LucideIcons.folderOpen, color: Theme.of(context).colorScheme.primary),
          onPressed: onShowFile,
          tooltip: 'Show File',
        );
        break;
      case DownloadFailed():
        progressValue = 0.0;
        statusText = 'Failed';
        trailingAction = IconButton(
          icon: Icon(LucideIcons.refreshCw, color: Theme.of(context).colorScheme.error),
          onPressed: onRetry,
          tooltip: 'Retry Transfer',
        );
        break;
      case DownloadCanceled():
        progressValue = 0.0;
        statusText = 'Canceled';
        trailingAction = IconButton(
          icon: const Icon(LucideIcons.refreshCw),
          onPressed: onRetry,
          tooltip: 'Restart Transfer',
        );
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Transfer status/direction icon indicator
            Icon(originIcon, size: 28, color: _getStatusColor(context, state)),
            const SizedBox(width: 16),

            // Core details area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.fileName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  Text(
                    "From: ${item.filePath}",
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Text(
                    "To: ${item.targetPath}",
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: progressValue),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                color: _getStatusColor(context, state),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(context, state),
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailingAction,
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, DownloadState state) {
    return switch (state) {
      Downloading() => Theme.of(context).colorScheme.primary,
      DownloadCompleted() => Colors.green,
      DownloadFailed() => Theme.of(context).colorScheme.error,
      DownloadCanceled() => Colors.grey,
    };
  }
}