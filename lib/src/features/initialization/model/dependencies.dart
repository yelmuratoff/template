import 'package:base_starter/src/core/di/containers/dependencies.dart';
import 'package:base_starter/src/core/di/containers/repositories.dart';

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
