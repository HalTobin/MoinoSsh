import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/title_header.dart';
import 'package:util/ssh/public_key_line.dart';

import '../../model/authorized_keys_file.dart';

/// Last look at what is about to be written to the remote `authorized_keys`.
class ConfirmApplyDialog extends StatelessWidget {
  final List<SshPublicKeyLine> additions;
  final List<AuthorizedKeyEntry> removals;
  final bool wouldRemoveEveryKey;
  final String authorizedKeysPath;
  final Function() onConfirm;
  final Function() onDismiss;

  const ConfirmApplyDialog({
    super.key,
    required this.additions,
    required this.removals,
    required this.wouldRemoveEveryKey,
    required this.authorizedKeysPath,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppDialogLayout(
      width: 520,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          TitleHeader(
            icon: LucideIcons.shieldCheck,
            title: 'Apply key changes?',
            trailingContent: TitleHeaderTrailingContent.dismissable(
              onDismiss: onDismiss,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              authorizedKeysPath,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (wouldRemoveEveryKey)
            _LockoutWarning(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  if (additions.isNotEmpty)
                    _ChangeGroup(
                      icon: LucideIcons.plus,
                      color: Colors.green,
                      title: 'Adding ${additions.length} key${additions.length == 1 ? '' : 's'}',
                      rows: additions
                          .map((key) => _ChangeRow(
                                label: key.comment ?? key.algorithmLabel,
                                detail: key.fingerprint,
                              ))
                          .toList(),
                    ),
                  if (removals.isNotEmpty)
                    _ChangeGroup(
                      icon: LucideIcons.trash2,
                      color: colorScheme.error,
                      title: 'Removing ${removals.length} key${removals.length == 1 ? '' : 's'}',
                      rows: removals
                          .map((entry) => _ChangeRow(
                                label: entry.comment ?? entry.algorithmLabel,
                                detail: entry.fingerprint,
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onDismiss,
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: AppButton(
                  onClick: onConfirm,
                  icon: LucideIcons.check,
                  text: 'Apply',
                  stretch: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LockoutWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 12,
        children: [
          const Icon(LucideIcons.triangleAlert, color: Colors.red),
          const Expanded(
            child: Text(
              'This removes every authorized key. Key based login will stop working '
              'for this account, including the session you are using now.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeGroup extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<_ChangeRow> rows;

  const _ChangeGroup({
    required this.icon,
    required this.color,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(icon, size: 18, color: color),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        ...rows,
      ],
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final String label;
  final String detail;

  const _ChangeRow({required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, overflow: TextOverflow.ellipsis),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
