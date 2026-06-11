// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:ui/src/widgets/shimmer/animator.dart';

/// Creates simple yet beautiful shimmer animations.
///
/// Shimmer is widely used as the default animation for skeleton loaders and
/// placeholder widgets. Wrap any [child] to overlay a moving highlight while
/// its real content is loading; see the field docs for the available knobs
/// ([color], [colorOpacity], [enabled], [duration], [direction]).
class Shimmer extends StatelessWidget {
  const Shimmer({
    required this.child,
    super.key,
    this.enabled = true,
    this.color = Colors.white,
    this.colorOpacity = 0.3,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = const ShimmerDirection.fromLTRB(),
    this.cornerRadius = 12,
  });

  /// Accepts a child [Widget] over which the animation is to be displayed
  final Widget child;

  /// Toggles the animation on/off. Defaults to true.
  final bool enabled;

  /// Color of the animation overlay. Defaults to [Colors.white].
  final Color color;

  /// Opacity of the animation overlay color. Defaults to 0.3.
  final double colorOpacity;

  /// Time period of one animation sweep. Defaults to 1500 milliseconds.
  final Duration duration;

  /// Direction along which the animation travels. Defaults to
  /// [ShimmerDirection.fromLTRB].
  final ShimmerDirection direction;

  /// Corner radius of the animation overlay. Defaults to 12.
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return ShimmerAnimator(
        color: color,
        opacity: colorOpacity,
        duration: duration,
        direction: direction,
        cornerRadius: cornerRadius,
        child: child,
      );
    } else {
      return child;
    }
  }
}

/// A direction along which the shimmer animation travels.
///
/// Diagonal: [ShimmerDirection.fromLTRB] (default),
/// [ShimmerDirection.fromRTLB], [ShimmerDirection.fromLBRT],
/// [ShimmerDirection.fromRBLT].
/// Along the axes: [ShimmerDirection.fromLeftToRight],
/// [ShimmerDirection.fromRightToLeft].
class ShimmerDirection {
  factory ShimmerDirection() => const ShimmerDirection._fromLTRB();
  const ShimmerDirection._fromLTRB({
    this.begin = Alignment.topLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRTLB({
    this.begin = Alignment.centerRight,
    this.end = Alignment.topLeft,
  });

  const ShimmerDirection._fromLBRT({
    this.begin = Alignment.bottomLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRBLT({
    this.begin = Alignment.topRight,
    this.end = Alignment.centerLeft,
  });

  const ShimmerDirection._fromLeftToRight({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  const ShimmerDirection._fromRightToLeft({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
  });

  /// Animation starts from Left Top and moves towards the Right Bottom
  const factory ShimmerDirection.fromLTRB() = ShimmerDirection._fromLTRB;

  /// Animation starts from Right Top and moves towards the Left Bottom
  const factory ShimmerDirection.fromRTLB() = ShimmerDirection._fromRTLB;

  /// Animation starts from Left Bottom and moves towards the Right Top
  const factory ShimmerDirection.fromLBRT() = ShimmerDirection._fromLBRT;

  /// Animation starts from Right Bottom and moves towards the Left Top
  const factory ShimmerDirection.fromRBLT() = ShimmerDirection._fromRBLT;

  /// Animation starts from Left Center and moves towards the Right Center
  const factory ShimmerDirection.fromLeftToRight() =
      ShimmerDirection._fromLeftToRight;

  /// Animation starts from Right Center and moves towards the Left Center
  const factory ShimmerDirection.fromRightToLeft() =
      ShimmerDirection._fromRightToLeft;
  final Alignment begin;
  final Alignment end;
}
