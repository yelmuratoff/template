import 'package:flutter/foundation.dart';

/// The environment.
enum EnvType {
  /// Development environment.
  dev._('DEV'),

  /// Production environment.
  prod._('PROD');

  /// The environment value.
  final String value;

  const EnvType._(this.value);

  /// Returns the environment from the given [value].
  static EnvType from(String? value) => switch (value) {
        'DEV' => EnvType.dev,
        'PROD' => EnvType.prod,
        _ => kReleaseMode ? EnvType.prod : EnvType.dev,
      };
}
