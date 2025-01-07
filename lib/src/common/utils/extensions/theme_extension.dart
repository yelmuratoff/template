import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

extension ThemeExtension on ThemeData {
  /// `colors` returns colors of the `BuildContext`.
  IColors get colors => extension<IColors>()!;

  /// `textStyles` returns text styles of the `BuildContext`.
  ITextStyles get textStyles => extension<ITextStyles>()!;
}
