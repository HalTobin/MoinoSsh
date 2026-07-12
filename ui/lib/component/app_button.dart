import 'package:flutter/material.dart';

class AppButton extends StatelessWidget  {
  final IconData? icon;
  final String text;
  final Function() onClick;

  final bool enabled;
  final double? maxWidth;
  final bool stretch;

  const AppButton({
    super.key,
    this.icon,
    required this.text,
    required this.onClick,
    this.enabled = true,
    this.maxWidth = null,
    this.stretch = false
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? (stretch ? double.infinity : 384)),
      child: AnimatedCrossFade(
        crossFadeState: enabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        firstChild: _Button(
          icon: icon,
          text: text,
          onClick: onClick,
          enabled: true,
          stretch: stretch
        ),
        secondChild: _Button(
          icon: icon,
          text: text,
          onClick: onClick,
          enabled: false,
          stretch: stretch
        ),
      )
    );
  }
}

class _Button extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Function() onClick;
  final bool enabled;
  final bool stretch;

  const _Button({
    super.key,
    required this.icon,
    required this.text,
    required this.onClick,
    required this.enabled,
    required this.stretch
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: stretch ? double.infinity : null,
      child: FilledButton.icon(
        onPressed: enabled ? onClick : null,
        icon: icon != null ? Icon(icon) : null,
        label: Text(text)
      )
    );
  }

}