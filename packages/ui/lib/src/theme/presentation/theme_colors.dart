import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ui/src/theme/domain/theme_colors.dart';

/// It has all required fields from the default Material `ColorScheme`.
/// But you can add, rename and delete any fields your need.
///
/// ### Motivation
///
/// At the beginning, you may not know if your colors will fit into the
/// Material `ColorScheme`,
/// but you still decided to start using `ColorScheme`, and only then realize
/// that you need additional fields.
/// You will create `ThemeExtension` for only the additional fields, and as the
/// result, you will have your colors
/// scattered between the `ColorScheme` and `ThemeExtension` with a few extra
/// colors.
///
/// With this template, you can collect all fields in one place,
/// and don't worry about future changes to the Material or your design.
///
/// Or you can just quickly copy-paste this file and rename
/// fields to your needs.
final class ThemeColors extends Equatable implements IColors {
  const ThemeColors({
    required this.card,
    required this.divider,
    required this.text,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.border,
    required this.shadow,
    required this.success,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  @override
  final Color card;
  @override
  final Color divider;
  @override
  final Color text;
  @override
  final Color primary;
  @override
  final Color onPrimary;
  @override
  final Color secondary;
  @override
  final Color onSecondary;
  @override
  final Color error;
  @override
  final Color onError;
  @override
  final Color background;
  @override
  final Color onBackground;
  @override
  final Color surface;
  @override
  final Color onSurface;
  @override
  final Color border;
  @override
  final Color shadow;
  @override
  final Color success;
  @override
  final Color shimmerBase;
  @override
  final Color shimmerHighlight;

  @override
  ThemeColors copyWith({
    Color? card,
    Color? divider,
    Color? text,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? onError,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? border,
    Color? shadow,
    Color? success,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) =>
      ThemeColors(
        card: card ?? this.card,
        divider: divider ?? this.divider,
        text: text ?? this.text,
        primary: primary ?? this.primary,
        onPrimary: onPrimary ?? this.onPrimary,
        secondary: secondary ?? this.secondary,
        onSecondary: onSecondary ?? this.onSecondary,
        error: error ?? this.error,
        onError: onError ?? this.onError,
        background: background ?? this.background,
        onBackground: onBackground ?? this.onBackground,
        surface: surface ?? this.surface,
        onSurface: onSurface ?? this.onSurface,
        border: border ?? this.border,
        shadow: shadow ?? this.shadow,
        success: success ?? this.success,
        shimmerBase: shimmerBase ?? this.shimmerBase,
        shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      );

  @override
  ThemeColors lerp(
    covariant ThemeColors? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      card: Color.lerp(card, other.card, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      text: Color.lerp(text, other.text, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      success: Color.lerp(success, other.success, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }

  @override
  List<Object?> get props => [
        card,
        divider,
        text,
        primary,
        onPrimary,
        secondary,
        onSecondary,
        error,
        onError,
        background,
        onBackground,
        surface,
        onSurface,
        border,
        shadow,
        success,
        shimmerBase,
        shimmerHighlight,
      ];

  @override
  Object get type => IColors;
}
