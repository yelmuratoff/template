import 'dart:ui';

final class ThemeUtil {
  /// `adjustColorBrightness` - This function adjusts the brightness of a color
  /// by the specified amount.
  static Color adjustColorBrightness(Color color, double brightness) {
    assert(
      brightness >= 0.0 && brightness <= 1.0,
      'Brightness must be between 0.0 and 1.0',
    );

    final red = (color.r * brightness) + (1.0 - brightness);
    final green = (color.g * brightness) + (1.0 - brightness);
    final blue = (color.b * brightness) + (1.0 - brightness);

    return color.withValues(alpha: color.a, red: red, green: green, blue: blue);
  }

  /// `adjustColorDarken` - This function darkens a color
  /// by the specified amount.
  static Color adjustColorDarken(Color color, double darken) {
    assert(
      darken >= 0.0 && darken <= 1.0,
      'Darken must be between 0.0 and 1.0',
    );

    final red = (color.r * (1.0 - darken)).round();
    final green = (color.g * (1.0 - darken)).round();
    final blue = (color.b * (1.0 - darken)).round();

    return Color.fromARGB(color.a.toInt(), red, green, blue);
  }
}
