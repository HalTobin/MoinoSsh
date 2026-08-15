import 'dart:async';

import 'package:feature_file_explorer/di/file_explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/navigation_type.dart';

import 'component/download_entry_item.dart';
import 'download_tracker_event.dart';
import 'download_tracker_state.dart';

class DownloadTrackerScreen extends StatefulWidget {
  final NavigationType navigationType;
  final bool isNarrow;
  final DownloadTrackerState state;
  final Function(DownloadTrackerEvent event) onEvent;
  final Stream<DownloadTrackerUiEvent> uiEvent;
  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  const DownloadTrackerScreen({
    super.key,
    required this.navigationType,
    required this.isNarrow,
    required this.state,
    required this.onEvent,
    required this.uiEvent,
    required this.title,
    required this.onBack,
    required this.actions,
  });

  @override
  State<DownloadTrackerScreen> createState() => _DownloadTrackerScreenState();
}

class _DownloadTrackerScreenState extends State<DownloadTrackerScreen> {
  StreamSubscription<DownloadTrackerUiEvent>? _uiEventSubscription;

  @override
  void initState() {
    super.initState();
    _uiEventSubscription = widget.uiEvent.listen(_handleUiEvent);
  }

  @override
  void didUpdateWidget(covariant DownloadTrackerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uiEvent != widget.uiEvent) {
      _uiEventSubscription?.cancel();
      _uiEventSubscription = widget.uiEvent.listen(_handleUiEvent);
    }
  }

  @override
  void dispose() {
    _uiEventSubscription?.cancel();
    super.dispose();
  }

  void _handleUiEvent(DownloadTrackerUiEvent event) {
    switch (event) {
      case OpenRemoteFileLocation():
        _openRemoteFileLocation(event.folderPath);
      case ShowFileFailed():
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(event.message)),
        );
    }
  }

  void _openRemoteFileLocation(String folderPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FileExplorerProvider(
          initialPath: folderPath,
          title: 'File explorer',
          onBack: () => Navigator.of(context).pop(),
          actions: widget.actions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isVertical = widget.navigationType == NavigationType.vertical;

    return Scaffold(
      appBar: AppBar(
        leading: isVertical
            ? null
            : IconButton(
                onPressed: widget.onBack,
                icon: const Icon(LucideIcons.arrowLeft),
              ),
        title: Text(isVertical ? 'Downloads' : widget.title),
        automaticallyImplyLeading: !isVertical,
        actions: isVertical
            ? [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                  tooltip: "Close",
                )
              ]
            : widget.actions,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: widget.state.items.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.downloadCloud, size: 48, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('No transfers to show', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: widget.state.items.length,
              itemBuilder: (context, index) {
                final item = widget.state.items[index];
                return DownloadEntryItem(
                  item: item,
                  onCancel: () => widget.onEvent(
                    CancelDownload(downloadSessionId: item.downloadSessionId),
                  ),
                  onRetry: () {},
                  onShowFile: () => widget.onEvent(ShowFile(item: item)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}
