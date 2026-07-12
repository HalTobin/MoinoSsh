import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/navigation_type.dart';

import 'component/download_entry_item.dart';
import 'download_tracker_state.dart';
import 'download_tracker_event.dart';

class DownloadTrackerScreen extends StatelessWidget {
  final NavigationType navigationType;
  final bool isNarrow;
  final DownloadTrackerState state;
  final Function(DownloadTrackerEvent event) onEvent;

  const DownloadTrackerScreen({
    super.key,
    required this.navigationType,
    required this.isNarrow,
    required this.state,
    required this.onEvent
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (navigationType == NavigationType.vertical)
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
            child: state.items.isEmpty
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
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return DownloadEntryItem(
                  item: item,
                  onCancel: () => onEvent(CancelDownload(downloadSessionId: item.downloadSessionId)),
                  onRetry: () {},
                  onShowFile: () {}
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}