import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FileFab extends StatefulWidget {
  final Function(FileFabAction) onAction;

  const FileFab({
    super.key,
    required this.onAction
  });

  @override
  State<StatefulWidget> createState() => FileFabState();

}

class FileFabState extends State<FileFab> {
  bool _isMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 150),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: AnimatedSlide(
                offset: _isMenuExpanded ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuad,
                child: child,
              ),
            );
          },
          child: _isMenuExpanded
              ? Column(
            key: const ValueKey('expanded_fab_menu'),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: FileFabAction.values.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0, right: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        action.actionText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton.small(
                    heroTag: 'fab_${action.identifier}',
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    onPressed: () {
                      setState(() => _isMenuExpanded = false);
                      widget.onAction(action);
                    },
                    child: Icon(action.actionIcon, size: 18),
                  ),
                ],
              ),
            )).toList(),
          )
              : const SizedBox.shrink(),
        ),

        FloatingActionButton.extended(
          heroTag: 'main_fab',
          onPressed: () {
            setState(() {
              _isMenuExpanded = !_isMenuExpanded;
            });
          },
          label: const Text('Add'),
          icon: AnimatedRotation(
            turns: _isMenuExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(LucideIcons.plus),
          ),
        ),
      ],
    );
  }

}

enum FileFabAction {
  newFile(
    position: 0,
    identifier: "new_file",
    actionText: "New file",
    actionIcon: LucideIcons.filePlus
  ),
  newFolder(
    position: 1,
    identifier: "new_folder",
    actionText: "New folder",
    actionIcon: LucideIcons.folderPlus
  ),
  uploadFile(
    position: 2,
    identifier: "upload_file",
    actionText: "Upload file",
    actionIcon: LucideIcons.upload
  );

  const FileFabAction({
    required this.position,
    required this.identifier,
    required this.actionText,
    required this.actionIcon
  });

  final int position;
  final String identifier;
  final String actionText;
  final IconData actionIcon;
}