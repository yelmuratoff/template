import 'package:base_starter/src/core/theme/domain/theme_colors.dart';
import 'package:base_starter/src/core/theme/domain/theme_text_styles.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on ThemeData {
  /// `colors` returns colors of the `BuildContext`.
  IColors get colors => extension<IColors>()!;

  /// `textStyles` returns text styles of the `BuildContext`.
  ITextStyles get textStyles => extension<ITextStyles>()!;
}
