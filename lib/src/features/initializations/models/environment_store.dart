import 'package:base_starter/flavors.dart';

/// Environment store
final class EnvironmentStore {
  const EnvironmentStore();

  /// The environment.
  static Flavor get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return Flavor.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Flavor.from(environment);
  }
}
