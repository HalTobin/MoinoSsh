import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final bool enable;
  final Function() onClick;

  const DeleteButton({
    super.key,
    required this.enable,
    required this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 384),
      child: SizedBox(
        height: 40,
        child: OutlinedButton.icon(
          onPressed: () => {
            if (enable) {
              onClick()
            }
          },
          icon: const Icon(LucideIcons.trash),
          label: Text("Delete")
        )
      )
    );
  }
}