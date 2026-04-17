import 'package:flutter/material.dart';

class AnimatedServiceActionButton extends StatelessWidget {
  final bool enable;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const AnimatedServiceActionButton({
    super.key,
    required this.enable,
    required this.icon,
    required this.color,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: enable ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
      firstChild: ServiceActionButton(
        enable: true,
        icon: icon,
        color: color,
        onPressed: onPressed
      ),
      secondChild: ServiceActionButton(
        enable: false,
        icon: icon,
        color: color,
        onPressed: onPressed
      )
    );
  }
}

class ServiceActionButton extends StatelessWidget {
  final bool enable;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  ServiceActionButton({
    super.key,
    required this.enable,
    required this.icon,
    required this.color,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.white,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}