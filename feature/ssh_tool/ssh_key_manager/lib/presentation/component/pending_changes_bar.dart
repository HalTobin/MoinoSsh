import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';

class PendingChangesBar extends StatelessWidget {
  final int pendingChangeCount;
  final bool applying;
  final Function() onApply;
  final Function() onDiscard;

  const PendingChangesBar({
    super.key,
    required this.pendingChangeCount,
    required this.applying,
    required this.onApply,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                  child: OutlinedButton(
                    onPressed: applying ? null : onDiscard,
                    child: const Text('Discard'),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onClick: onApply,
                    icon: LucideIcons.check,
                    text: applying ? 'Applying...' : 'Apply',
                    enabled: !applying,
                    stretch: true,
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
