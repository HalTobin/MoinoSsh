import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PlayRippleIndicator extends StatefulWidget {
  const PlayRippleIndicator({super.key});

  @override
  State<PlayRippleIndicator> createState() => _PlayRippleIndicatorState();
}

class _PlayRippleIndicatorState extends State<PlayRippleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust speed
    )..repeat(); // Infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding and fading circle
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _controller.value;
              final scale = Tween<double>(begin: 0.6, end: 1.4).evaluate(_controller);
              final opacity = _animatedOpacity(progress);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                  ),
                ),
              );
            },
          ),

          // Centered Play Icon
          const Icon(
            LucideIcons.play,
            color: Colors.green,
            size: 24,
          ),
        ],
      ),
    );
  }

  double _animatedOpacity(double t) {
    if (t < 0.5) {
      return t * 2; // Fade in (0.0 → 1.0)
    } else {
      return (1.0 - t) * 2; // Fade out (1.0 → 0.0)
    }
  }

}