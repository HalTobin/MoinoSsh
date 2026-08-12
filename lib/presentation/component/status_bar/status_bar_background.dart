import 'package:flutter/material.dart';

class StatusBarBackground extends StatelessWidget {
  final bool connected;

  const StatusBarBackground({
    super.key,
    required this.connected
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;

        return Stack(
          children: [
            SizedBox(
              width: fullWidth,
              height: double.infinity,
              child: ColoredBox(color: colorScheme.surface),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: connected ? fullWidth : 0,
              color: colorScheme.primaryContainer
            ),
          ],
        );
      }
    );
  }

}