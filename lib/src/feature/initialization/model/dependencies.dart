import 'package:base_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependencies container
base class Dependencies {
  Dependencies();

  /// Shared preferences
  late final SharedPreferences sharedPreferences;

  /// Settings bloc
  late final SettingsBloc settingsBloc;

  /// Package info
  late final PackageInfo packageInfo;
}

/// Repositories container
base class Repositories {
  Repositories();
}

/// Result of initialization
final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.repositories,
    required this.stepCount,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The repositories
  final Repositories repositories;

  /// The number of steps
  final int stepCount;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => '$InitializationResult('
      'dependencies: $dependencies, '
      'repositories: $repositories, '
      'stepCount: $stepCount, '
      'msSpent: $msSpent'
      ')';
}
