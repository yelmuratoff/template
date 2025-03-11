import 'package:flutter/material.dart';
import 'package:ui/src/widgets/shimmer/animation.dart';
import 'package:ui/src/widgets/shimmer/shimmer.dart';

class ShimmerAnimator extends StatefulWidget {
  const ShimmerAnimator({
    super.key,
    required this.child,
    required this.color,
    required this.opacity,
    required this.duration,
    required this.direction,
    required this.cornerRadius,
  });
  final Color color;
  final double opacity;
  final Duration duration;

  final ShimmerDirection direction;
  final Widget child;
  final double cornerRadius;

  @override
  State<ShimmerAnimator> createState() => _ShimmerAnimatorState();
}

// Animator state controls the animation using all the parameters defined
class _ShimmerAnimatorState extends State<ShimmerAnimator>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1),
      ),
    )..addListener(() {
        if (_controller.isCompleted) {
          _controller.forward(from: 0);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _controller,
        builder: (context, child) => CustomPaint(
          foregroundPainter: CustomSplashAnimation(
            context: context,
            position: _animation.value,
            color: widget.color,
            opacity: widget.opacity,
            begin: widget.direction.begin,
            end: widget.direction.end,
            cornerRadius: widget.cornerRadius,
          ),
          child: widget.child,
        ),
      );
}
