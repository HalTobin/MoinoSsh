import 'dart:io';

import 'package:domain/model/sftp/download_item.dart';
import 'package:feature_file_explorer/util/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DownloadEntryItem extends StatefulWidget {
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
  State<DownloadEntryItem> createState() => _DownloadEntryItemState();
}

class _DownloadEntryItemState extends State<DownloadEntryItem> {
  bool _canShowFile = true;

  @override
  void initState() {
    super.initState();
    _refreshShowFileAvailability();
  }

  @override
  void didUpdateWidget(covariant DownloadEntryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.downloadSessionId != widget.item.downloadSessionId ||
        oldWidget.item.targetPath != widget.item.targetPath ||
        oldWidget.item.state.runtimeType != widget.item.state.runtimeType) {
      _refreshShowFileAvailability();
    }
  }

  Future<void> _refreshShowFileAvailability() async {
    final item = widget.item;
    if (item.state is! DownloadCompleted) {
      if (mounted) {
        setState(() => _canShowFile = false);
      }
      return;
    }

    if (item.origin == DownloadOrigin.local) {
      if (mounted) {
        setState(() => _canShowFile = true);
      }
      return;
    }

    final exists = await File(item.targetPath).exists();
    if (mounted) {
      setState(() => _canShowFile = exists);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final state = item.state;

    final IconData originIcon = item.origin == DownloadOrigin.local
        ? LucideIcons.uploadCloud
        : LucideIcons.downloadCloud;

    double progressValue = 0.0;
    String statusText = '';
    final isCanceled = state is DownloadCanceled;

    final Widget trailingAction = switch (state) {
      Downloading() => IconButton(
        icon: const Icon(LucideIcons.x, color: Colors.grey),
        onPressed: widget.onCancel,
        tooltip: 'Cancel Transfer',
      ),
      DownloadCompleted() => IconButton(
        icon: Icon(
          LucideIcons.folderOpen,
          color: _canShowFile
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        onPressed: _canShowFile ? widget.onShowFile : null,
        tooltip: _canShowFile ? 'Show File' : 'File no longer available',
      ),
      DownloadFailed() => IconButton(
        icon: Icon(LucideIcons.refreshCw, color: Theme.of(context).colorScheme.error),
        onPressed: widget.onRetry,
        tooltip: 'Retry Transfer',
      ),
      DownloadCanceled() => IconButton(
        icon: const Icon(LucideIcons.refreshCw),
        onPressed: widget.onRetry,
        tooltip: 'Restart Transfer',
      ),
    };

    switch (state) {
      case Downloading():
        progressValue = state.progress;
        statusText = '${(state.progress * 100).toStringAsFixed(1)}%';
      case DownloadCompleted():
        progressValue = 1.0;
        statusText = 'Completed';
      case DownloadFailed():
        progressValue = 0.0;
        statusText = 'Failed';
      case DownloadCanceled():
        progressValue = state.transferredBytes > 0 && item.size > 0
            ? state.transferredBytes / item.size
            : 0.0;
        statusText = 'Canceled';
    }

    final mutedStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: isCanceled
          ? Colors.grey
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );

    final card = Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              originIcon,
              size: 28,
              color: _getStatusColor(context, state),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.fileName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isCanceled ? Colors.grey : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'From: ${item.filePath}',
                    style: mutedStyle?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'To: ${item.targetPath}',
                    style: mutedStyle?.copyWith(fontStyle: FontStyle.italic),
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
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
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
                  const SizedBox(height: 4),
                  Text(
                    _transferDetails(item),
                    style: mutedStyle?.copyWith(fontFamily: 'monospace'),
                  ),
                  if (state is DownloadCompleted && !_canShowFile) ...[
                    const SizedBox(height: 2),
                    Text(
                      'File no longer available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailingAction,
          ],
        ),
      ),
    );

    if (!isCanceled) {
      return card;
    }

    return Opacity(
      opacity: 0.55,
      child: card,
    );
  }

  String _transferDetails(DownloadItem item) {
    final transferred = SizeHelper.formatSize(item.state.transferredBytes);
    final total = SizeHelper.formatSize(item.size);
    final details = '$transferred / $total';

    final state = item.state;
    if (state is Downloading && state.bytesPerSecond > 0) {
      final speed = SizeHelper.formatSize(state.bytesPerSecond.round());
      return '$details · $speed/s';
    }
    return details;
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
