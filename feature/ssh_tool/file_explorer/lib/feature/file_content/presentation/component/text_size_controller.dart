import 'package:feature_file_explorer/feature/file_content/presentation/component/text_content/content_text_value.dart';
import 'package:feature_file_explorer/feature/file_content/presentation/file_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:ui/component/title_header.dart';

class TextSizeController extends StatelessWidget {
  final bool isNarrow;
  final Function(double) onTextSizeChange;

  const TextSizeController({
    super.key,
    required this.isNarrow,
    required this.onTextSizeChange,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FileContentViewModel>();

    if (isNarrow) {
      return _buildButton(
        onPressed: () => _showBottomSheet(context)
      );
    }

    return MenuAnchor(
      alignmentOffset: const Offset(-8, 12),
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      menuChildren: [
        ChangeNotifierProvider.value(
          value: viewModel,
          child: Builder(
            builder: (innerContext) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildControlRow(innerContext),
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return _buildButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }

  Widget _buildButton({required Function() onPressed}) {
    return IconButton(
      icon: const Icon(LucideIcons.aLargeSmall),
      onPressed: onPressed,
    );
  }

  void _showBottomSheet(BuildContext context) {
    final viewModel = context.read<FileContentViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleHeader(
                  icon: LucideIcons.aLargeSmall,
                  title: "Text Size",
                  trailingContent: TitleHeaderTrailingContent.dismissable(
                      onDismiss: () => Navigator.of(context).pop()
                  ),
                ),
                const SizedBox(height: 16),
                _buildControlRow(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlRow(BuildContext context) {
    return Consumer<FileContentViewModel>(
      builder: (context, viewModel, child) {
        final textSize = viewModel.state.textSize;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.zoomOut),
              onPressed: textSize > ContentTextValue.minTextSize ? () => onTextSizeChange(textSize - 1) : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                textSize.toInt().toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [ FontFeature.tabularFigures() ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.zoomIn),
              onPressed: textSize < ContentTextValue.maxTextSize ? () => onTextSizeChange(textSize + 1) : null,
            ),
          ],
        );
      }
    );
  }

}