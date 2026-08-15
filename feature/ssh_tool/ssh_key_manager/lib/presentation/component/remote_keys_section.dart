import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/empty_list.dart';
import 'package:util/ssh/public_key_line.dart';

import '../../model/authorized_keys_file.dart';

class RemoteKeysSection extends StatelessWidget {
  final List<AuthorizedKeyEntry> remoteKeys;
  final List<SshPublicKeyLine> stagedKeys;
  final Function(int id) onToggleDeletion;

  const RemoteKeysSection({
    super.key,
    required this.remoteKeys,
    required this.stagedKeys,
    required this.onToggleDeletion,
  });

  @override
  Widget build(BuildContext context) {
    final hasEntries = remoteKeys.isNotEmpty || stagedKeys.isNotEmpty;

    if (!hasEntries) {
      return const EmptyList(
        message: 'No authorized keys on remote server',
        onAction: null,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: remoteKeys.length + stagedKeys.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        if (index < remoteKeys.length) {
          final entry = remoteKeys[index];
          return _RemoteKeyItem(
            title: entry.comment ?? entry.algorithmLabel,
            algorithmLabel: entry.algorithmLabel,
            fingerprint: entry.fingerprint,
            markedForDeletion: entry.markedForDeletion,
            isPendingAddition: false,
            onToggleDeletion: () => onToggleDeletion(entry.id),
          );
        }

        final staged = stagedKeys[index - remoteKeys.length];
        return _RemoteKeyItem(
          title: staged.comment ?? staged.algorithmLabel,
          algorithmLabel: staged.algorithmLabel,
          fingerprint: staged.fingerprint,
          markedForDeletion: false,
          isPendingAddition: true,
          onToggleDeletion: null,
        );
      },
    );
  }
}

class _RemoteKeyItem extends StatelessWidget {
  final String title;
  final String algorithmLabel;
  final String fingerprint;
  final bool markedForDeletion;
  final bool isPendingAddition;
  final Function()? onToggleDeletion;

  const _RemoteKeyItem({
    required this.title,
    required this.algorithmLabel,
    required this.fingerprint,
    required this.markedForDeletion,
    required this.isPendingAddition,
    required this.onToggleDeletion,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final strikeThrough = markedForDeletion ? TextDecoration.lineThrough : null;
    final color = markedForDeletion ? colorScheme.error : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isPendingAddition ? LucideIcons.plus : LucideIcons.key,
        color: isPendingAddition
            ? Colors.green
            : markedForDeletion
                ? colorScheme.error
                : null,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: strikeThrough,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            algorithmLabel,
            style: TextStyle(decoration: strikeThrough, color: color),
          ),
          Text(
            fingerprint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              decoration: strikeThrough,
              color: color ?? colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: isPendingAddition
          ? const Chip(label: Text('Pending'))
          : IconButton(
              icon: Icon(
                markedForDeletion ? LucideIcons.undo : LucideIcons.trash2,
                color: markedForDeletion ? colorScheme.primary : colorScheme.error,
              ),
              onPressed: onToggleDeletion,
              tooltip: markedForDeletion ? 'Undo deletion' : 'Mark for deletion',
            ),
    );
  }
}
