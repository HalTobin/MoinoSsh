import 'dart:async';

import 'package:feature_file_explorer/feature/image_viewer/presentation/component/image_info_modal.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/component/image_viewer_title.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_event.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_state.dart';
import 'package:feature_file_explorer/feature/image_viewer/presentation/image_viewer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/navigation/auto_modal.dart';

class ImageViewerScreen extends StatefulWidget {
  final ImageViewerState state;
  final Function(ImageViewerEvent) onEvent;
  final Stream<ImageViewerUiEvent> uiEvent;

  const ImageViewerScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.uiEvent,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late StreamSubscription _uiSubscription;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _uiSubscription = widget.uiEvent.listen((event) {
      switch (event) {
        case OpenImageInfoModal():
          _showImageInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        title: ImageViewerTitle(
          fileName: widget.state.file?.name ?? "",
          filePath: widget.state.filePath,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.info),
            onPressed: widget.state.file == null
                ? null
                : () => widget.onEvent(ShowImageInfo()),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final errorMessage = widget.state.errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, color: Theme.of(context).colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(
              "Failed to load image",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => widget.onEvent(ReloadImage()),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (widget.state.loading || widget.state.file == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 8,
      child: Center(
        child: Image.memory(
          widget.state.file!.bytes,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.imageOff, color: Theme.of(context).colorScheme.error, size: 48),
                const SizedBox(height: 16),
                const Text("Unsupported or corrupted image"),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showImageInfo() {
    final file = widget.state.file;
    if (file == null) return;

    final constraints = MediaQuery.of(context).size;
    autoModal(
      context: context,
      constraints: BoxConstraints(
        maxWidth: constraints.width,
        maxHeight: constraints.height,
      ),
      child: ImageInfoModal(
        file: file,
        metadata: widget.state.metadata,
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _transformationController.dispose();
    super.dispose();
  }
}
