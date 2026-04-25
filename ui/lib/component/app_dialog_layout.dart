import 'package:flutter/material.dart';

class AppDialogLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double width;

  const AppDialogLayout({
    super.key,
    this.padding = const EdgeInsets.all(12),
    required this.child,
    this.width = 386
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: width,
          child: child
        ),
      )
    );
  }
}