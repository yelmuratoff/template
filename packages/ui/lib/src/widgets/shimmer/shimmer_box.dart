import 'package:flutter/material.dart';
import 'package:ui/src/extensions/theme.dart';
import 'package:ui/src/widgets/shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width = 80,
    this.height = 16,
    this.radius = 12,
    this.color,
    this.backgroundColor,
    this.direction,
    this.border,
  });
  factory ShimmerBox.light({
    double? width,
    double? height,
    double radius = 12,
    ShimmerDirection? direction,
    BoxBorder? border,
  }) =>
      ShimmerBox(
        width: width,
        height: height,
        radius: radius,
        color: const Color(0xffEAECED),
        backgroundColor: const Color(0xFFFFFFFF),
        direction: direction,
        border: border,
      );

  factory ShimmerBox.dark({
    double? width,
    double? height,
    double radius = 12,
    ShimmerDirection? direction,
    BoxBorder? border,
  }) =>
      ShimmerBox(
        width: width,
        height: height,
        radius: radius,
        color: const Color(0xff505051),
        backgroundColor: const Color(0xFF000000),
        direction: direction,
        border: border,
      );

  final double? width;
  final double? height;
  final double radius;
  final Color? color;
  final Color? backgroundColor;
  final ShimmerDirection? direction;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) => Shimmer(
        color: backgroundColor ??
            Theme.of(context).whenByValue(
              light: const Color(0xFFFFFFFF),
              dark: const Color(0xFF000000),
            ),
        colorOpacity: 0.4,
        cornerRadius: radius,
        direction: direction ?? const ShimmerDirection.fromLeftToRight(),
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              color: color ??
                  Theme.of(context).whenByValue(
                    light: const Color(0xffEAECED),
                    dark: const Color(0xff505051),
                  ),
            ),
          ),
        ),
      );
}
