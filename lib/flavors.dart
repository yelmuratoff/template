import 'package:flutter/foundation.dart';

enum Flavor {
  /// Development environment.
  dev._('dev'),

  /// Production environment.
  prod._('prod');

  const Flavor._(this.value);

  /// The environment value.
  final String value;

  /// Returns the environment from the given [value].
  static Flavor from(String? value) => switch (value) {
        'dev' => Flavor.dev,
        'prod' => Flavor.prod,
        _ => kReleaseMode ? Flavor.prod : Flavor.dev,
      };
}

final class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title => switch (appFlavor) {
        Flavor.prod => 'Base',
        Flavor.dev => 'Base [Dev]',
        _ => 'Base',
      };

  static bool get isProd => appFlavor == Flavor.prod;

  static bool get isDev => appFlavor == Flavor.dev;
}
