import 'package:flutter/material.dart';

class ShakingWidget extends StatefulWidget {
  final bool shake;
  final int radius;
  final Widget child;

  const ShakingWidget({
    super.key,
    required this.shake,
    this.radius = 2,
    required this.child,
  });

  @override
  _ShakingWidgetState createState() => _ShakingWidgetState();
}

class _ShakingWidgetState extends State<ShakingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 125), // Fast and smooth
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: -(widget.radius) / 180,
      end: widget.radius / 180,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.shake) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ShakingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shake && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.shake && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.shake ? _rotationAnimation.value : 0,
          child: widget.child,
        );
      },
    );
  }
}