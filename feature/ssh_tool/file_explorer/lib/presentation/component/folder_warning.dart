import 'package:flutter/material.dart';

class FolderWarning extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const FolderWarning({
    super.key,
    required this.icon,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Icon(icon, color: color, size: 64),
          Text(text, style: TextStyle(color: color, fontSize: 16))
        ],
      ),
    );
  }

}