import 'package:flutter/material.dart';

class CustomSplashAnimation extends CustomPainter {
  CustomSplashAnimation({
    required this.context,
    required this.position,
    required this.color,
    required this.opacity,
    required this.begin,
    required this.end,
    required this.cornerRadius, // Добавлен параметр cornerRadius
  });
  final BuildContext context;
  double position;
  double opacity;
  double width = 0.2;
  final Color color;
  final Alignment begin;
  final Alignment end;
  final double cornerRadius; // Поле cornerRadius

  // Custom Painter to paint one frame of the animation. This is called in a loop to animate
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final stops = [
      0.0,
      position,
      if ((position + width) > 1) 1.0 else position + width,
      if ((position + (width * 2)) > 1) 1.0 else position + (width * 2),
      1.0,
    ];
    paint
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        tileMode: TileMode.decal,
        begin: begin,
        end: end,
        stops: stops,
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.05),
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTRB(
          size.width * -0.5,
          (size.height > size.width) ? 0 : size.height * -0.5,
          size.width * 1.5,
          size.height * 1.5,
        ),
      );

    // Используем RRect для рисования прямоугольника с закругленными углами
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
