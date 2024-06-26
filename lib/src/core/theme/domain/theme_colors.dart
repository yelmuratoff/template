import 'package:flutter/material.dart';

abstract interface class IColors extends ThemeExtension<IColors> {
  abstract final Color card;
  abstract final Color divider;
  abstract final Color text;
  abstract final Color primary;
  abstract final Color onPrimary;
  abstract final Color secondary;
  abstract final Color onSecondary;
  abstract final Color error;
  abstract final Color onError;
  abstract final Color background;
  abstract final Color onBackground;
  abstract final Color surface;
  abstract final Color onSurface;
  abstract final Color border;
  abstract final Color shadow;
  abstract final Color success;
  abstract final Color shimmerBase;
  abstract final Color shimmerHighlight;
}
