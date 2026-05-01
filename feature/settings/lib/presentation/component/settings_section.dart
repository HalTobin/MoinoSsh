import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  final String title;
  final bool showDivider;

  const SettingSection({
    super.key,
    required this.title,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Divider(height: 1, thickness: 0.5),
          ),
      ],
    );
  }
}