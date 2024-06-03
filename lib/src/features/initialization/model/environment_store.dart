import 'package:base_starter/src/features/initialization/model/env_type.dart';

/// Environment store
final class EnvironmentStore {
  const EnvironmentStore();

  /// The environment.
  static EnvType get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return EnvType.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return EnvType.from(environment);
  }
}
