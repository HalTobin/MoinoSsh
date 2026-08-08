import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/component/app_button.dart';
import 'package:ui/component/empty_list.dart';

import '../../model/authorized_key_entry.dart';

class RemoteKeysSection extends StatelessWidget {
  final List<AuthorizedKeyEntry> remoteKeys;
  final List<String> stagedPublicKeyLines;
  final Function(String line) onToggleDeletion;
  final Function() onGenerateKey;

  const RemoteKeysSection({
    super.key,
    required this.remoteKeys,
    required this.stagedPublicKeyLines,
    required this.onToggleDeletion,
    required this.onGenerateKey,
  });

  @override
  Widget build(BuildContext context) {
    final hasEntries = remoteKeys.isNotEmpty || stagedPublicKeyLines.isNotEmpty;

    return SizedBox.expand(
      child: Column(
      spacing: 16,
      children: [
        Expanded(
          child: hasEntries
              ? ListView.separated(
                  itemCount: remoteKeys.length + stagedPublicKeyLines.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    if (index < remoteKeys.length) {
                      final entry = remoteKeys[index];
                      return _RemoteKeyItem(
                        title: entry.comment ?? _shortKey(entry.line),
                        subtitle: entry.line,
                        markedForDeletion: entry.markedForDeletion,
                        isPendingAddition: false,
                        onToggleDeletion: () => onToggleDeletion(entry.line),
                      );
                    }

                    final stagedLine = stagedPublicKeyLines[index - remoteKeys.length];
                    return _RemoteKeyItem(
                      title: _shortKey(stagedLine),
                      subtitle: stagedLine,
                      markedForDeletion: false,
                      isPendingAddition: true,
                      onToggleDeletion: null,
                    );
                  },
                )
              : EmptyList(message: 'No authorized keys on remote server', onAction: null),
        ),
        AppButton(
          onClick: onGenerateKey,
          icon: LucideIcons.bookKey,
          text: 'GENERATE KEY PAIR',
          stretch: true,
        ),
      ],
      ),
    );
  }

  static String _shortKey(String line) {
    final parts = line.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return parts.length > 2 ? parts.sublist(2).join(' ') : parts.first;
    }
    return line;
  }
}

class _RemoteKeyItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool markedForDeletion;
  final bool isPendingAddition;
  final Function()? onToggleDeletion;

  const _RemoteKeyItem({
    required this.title,
    required this.subtitle,
    required this.markedForDeletion,
    required this.isPendingAddition,
    required this.onToggleDeletion,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        style: TextStyle(
          decoration: markedForDeletion ? TextDecoration.lineThrough : null,
          color: markedForDeletion ? colorScheme.error : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: markedForDeletion ? TextDecoration.lineThrough : null,
          color: markedForDeletion ? colorScheme.error : null,
        ),
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
