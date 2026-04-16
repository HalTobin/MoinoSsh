import 'package:flutter/material.dart';

class AuthTabLayout extends StatelessWidget {
  final Widget child;

  const AuthTabLayout({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: child
    );
  }

}