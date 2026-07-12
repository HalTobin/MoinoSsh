import 'package:flutter/material.dart';

class AuthScreenTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const AuthScreenTab({
    super.key,
    required this.title,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      )
    );
  }

}