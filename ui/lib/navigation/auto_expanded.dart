import 'package:flutter/material.dart';

class AutoExpanded extends StatelessWidget {
  final bool isShrink;
  final Widget child;

  const AutoExpanded({
    super.key,
    required this.isShrink,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return isShrink
      ? SizedBox(height: 256, child: child)
      : Expanded(child: child);
  }

}