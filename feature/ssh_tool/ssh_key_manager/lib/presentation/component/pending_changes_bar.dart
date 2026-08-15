import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';

class PendingChangesBar extends StatelessWidget {
  final int pendingChangeCount;
  final bool applying;
  final bool canApply;
  final Function() onApply;
  final Function() onDiscard;

  static const double _buttonHeight = 40;

  const PendingChangesBar({
    super.key,
    required this.pendingChangeCount,
    required this.applying,
    required this.canApply,
    required this.onApply,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Row(
              spacing: 8,
              children: [
                const Icon(LucideIcons.clock),
                Expanded(
                  child: Text(
                    '$pendingChangeCount pending remote change${pendingChangeCount == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: SizedBox(
                    height: _buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: applying ? null : onDiscard,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                      ),
                      icon: const Icon(LucideIcons.x),
                      label: const Text('Discard'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: _buttonHeight,
                    child: AppButton(
                      onClick: onApply,
                      icon: LucideIcons.check,
                      text: applying ? 'Applying...' : 'Apply',
                      enabled: canApply && !applying,
                      stretch: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
