import 'package:base_starter/src/common/theme/presentation/theme_colors.dart';
import 'package:base_starter/src/common/theme/presentation/theme_text_style.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on ThemeData {
  /// `colors` returns colors of the `BuildContext`.
  ThemeColors get colors => extension<ThemeColors>()!;

  /// `textStyles` returns text styles of the `BuildContext`.
  ThemeTextStyle get textStyles => extension<ThemeTextStyle>()!;
}
