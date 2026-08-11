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

  const DownloadTrackerScreen({
    super.key,
    required this.navigationType,
    required this.isNarrow,
    required this.state,
    required this.onEvent,
    required this.uiEvent,
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
    }
  }

  void _openRemoteFileLocation(String folderPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('File explorer'),
          ),
          body: FileExplorerProvider(initialPath: folderPath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.navigationType == NavigationType.vertical)
        ? AppBar(
          title: const Text('Downloads'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(LucideIcons.x),
              tooltip: "Close",
            )
          ],
        )
        : null,
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
