import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../model/server_profile_ui.dart';

class ServerProfileItem extends StatelessWidget {
  final ServerProfileUi profile;
  final Function() onConnect;
  final Function() onEdit;

  const ServerProfileItem({
    super.key,
    required this.profile,
    required this.onConnect,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 500;
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 6),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: !isNarrow
                ? _buildExpandedCard()
                : _buildNarrowedCard(context)
            ),
          ),
        );
      }
    );
  }

  Widget _buildExpandedCard() {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: _BaseServerProfileItem(profile: profile),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.pen, size: 18),
              tooltip: "Edit Profile",
              onPressed: onEdit,
            ),

            const SizedBox(width: 4),

            FilledButton.tonal(
              onPressed: onConnect,
              child: const Text("Connect"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowedCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double buttonHeight = 40.0;
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BaseServerProfileItem(profile: profile),
        Row(
          spacing: 12,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton.filled(
              onPressed: onEdit,
              icon: const Icon(LucideIcons.pen),
              iconSize: 22.0,
              style: IconButton.styleFrom(
                foregroundColor: colorScheme.onSecondaryContainer,
                backgroundColor: colorScheme.secondaryContainer,
                fixedSize: const Size(buttonHeight, buttonHeight),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Expanded(
              child: FilledButton.icon(
                onPressed: onConnect,
                icon: const Icon(LucideIcons.terminal),
                label: const Text("CONNECT"),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, buttonHeight),
                  fixedSize: const Size.fromHeight(buttonHeight),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              )
            )
          ],
        ),
      ],
    );
  }

}

class _BaseServerProfileItem extends StatelessWidget {
  final ServerProfileUi profile;

  const _BaseServerProfileItem({
    super.key,
    required this.profile
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            if (profile.keyRequiresPassword)
              const Icon(LucideIcons.lock, size: 16),
            Text(
              profile.name ?? "#${profile.id}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Text(
          profile.getIdentifier(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}