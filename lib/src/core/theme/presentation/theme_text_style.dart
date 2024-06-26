import 'package:base_starter/src/core/theme/domain/theme_text_styles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class ThemeTextStyle extends Equatable implements ITextStyles {
  const ThemeTextStyle({
    required this.error,
    required this.s9w600,
    required this.s10w400,
    required this.s12w400,
    required this.s12w500,
    required this.s12w600,
    required this.s12w700,
    required this.s14w400,
    required this.s14w500,
    required this.s14w600,
    required this.s14w700,
    required this.s16w400,
    required this.s16w500,
    required this.s16w600,
    required this.s16w700,
    required this.s18w600,
    required this.s20w400,
    required this.s20w500,
    required this.s20w600,
    required this.s24w700,
    required this.s36w400,
  });

  @override
  final TextStyle error;
  @override
  final TextStyle s9w600;
  @override
  final TextStyle s10w400;
  @override
  final TextStyle s12w400;
  @override
  final TextStyle s12w500;
  @override
  final TextStyle s12w600;
  @override
  final TextStyle s12w700;
  @override
  final TextStyle s14w400;
  @override
  final TextStyle s14w500;
  @override
  final TextStyle s14w600;
  @override
  final TextStyle s14w700;
  @override
  final TextStyle s16w400;
  @override
  final TextStyle s16w500;
  @override
  final TextStyle s16w600;
  @override
  final TextStyle s16w700;
  @override
  final TextStyle s18w600;
  @override
  final TextStyle s20w400;
  @override
  final TextStyle s20w500;
  @override
  final TextStyle s20w600;
  @override
  final TextStyle s24w700;
  @override
  final TextStyle s36w400;

  @override
  List<Object?> get props => [
        error,
        s9w600,
        s10w400,
        s12w400,
        s12w500,
        s12w600,
        s12w700,
        s14w400,
        s14w500,
        s14w600,
        s14w700,
        s16w400,
        s16w500,
        s16w600,
        s16w700,
        s18w600,
        s20w400,
        s20w500,
        s20w600,
        s24w700,
        s36w400,
      ];

  @override
  ThemeTextStyle copyWith({
    TextStyle? error,
    TextStyle? s9w600,
    TextStyle? s10w400,
    TextStyle? s12w400,
    TextStyle? s12w500,
    TextStyle? s12w600,
    TextStyle? s12w700,
    TextStyle? s14w400,
    TextStyle? s14w500,
    TextStyle? s14w600,
    TextStyle? s14w700,
    TextStyle? s16w400,
    TextStyle? s16w500,
    TextStyle? s16w600,
    TextStyle? s16w700,
    TextStyle? s18w600,
    TextStyle? s20w400,
    TextStyle? s20w500,
    TextStyle? s20w600,
    TextStyle? s24w700,
    TextStyle? s36w400,
  }) =>
      ThemeTextStyle(
        error: error ?? this.error,
        s9w600: s9w600 ?? this.s9w600,
        s10w400: s10w400 ?? this.s10w400,
        s12w400: s12w400 ?? this.s12w400,
        s12w500: s12w500 ?? this.s12w500,
        s12w600: s12w600 ?? this.s12w600,
        s12w700: s12w700 ?? this.s12w700,
        s14w400: s14w400 ?? this.s14w400,
        s14w500: s14w500 ?? this.s14w500,
        s14w600: s14w600 ?? this.s14w600,
        s14w700: s14w700 ?? this.s14w700,
        s16w400: s16w400 ?? this.s16w400,
        s16w500: s16w500 ?? this.s16w500,
        s16w600: s16w600 ?? this.s16w600,
        s16w700: s16w700 ?? this.s16w700,
        s18w600: s18w600 ?? this.s18w600,
        s20w400: s20w400 ?? this.s20w400,
        s20w500: s20w500 ?? this.s20w500,
        s20w600: s20w600 ?? this.s20w600,
        s24w700: s24w700 ?? this.s24w700,
        s36w400: s36w400 ?? this.s36w400,
      );

  @override
  ITextStyles lerp(ThemeExtension<ITextStyles>? other, double t) => this;

  @override
  Object get type => ITextStyles;
}
