import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ExpandableFabAction {
  final String id;
  final String label;
  final IconData icon;

  const ExpandableFabAction({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class ExpandableFab extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<ExpandableFabAction> actions;
  final ValueChanged<ExpandableFabAction> onAction;
  final String heroTagPrefix;

  const ExpandableFab({
    super.key,
    this.label = 'Add',
    this.icon = LucideIcons.plus,
    required this.actions,
    required this.onAction,
    this.heroTagPrefix = 'expandable_fab',
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  key: ValueKey('${widget.heroTagPrefix}_expanded_menu'),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.actions.map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, right: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 2,
                            color: colorScheme.surfaceContainer,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Text(
                                action.label,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FloatingActionButton.small(
                            heroTag: '${widget.heroTagPrefix}_${action.id}',
                            backgroundColor: colorScheme.secondaryContainer,
                            foregroundColor: colorScheme.onSecondaryContainer,
                            onPressed: () {
                              setState(() => _isMenuExpanded = false);
                              widget.onAction(action);
                            },
                            child: Icon(action.icon, size: 18),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : const SizedBox.shrink(),
        ),
        FloatingActionButton.extended(
          heroTag: '${widget.heroTagPrefix}_main',
          onPressed: () {
            setState(() {
              _isMenuExpanded = !_isMenuExpanded;
            });
          },
          label: Text(widget.label),
          icon: AnimatedRotation(
            turns: _isMenuExpanded ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(widget.icon),
          ),
        ),
      ],
    );
  }
}
