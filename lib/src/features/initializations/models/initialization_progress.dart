import 'package:base_starter/src/core/di/containers/dependencies.dart';
import 'package:base_starter/src/core/di/containers/repositories.dart';
import 'package:base_starter/src/features/initializations/models/environment_store.dart';

/// A class which represents the initialization progress.
final class InitializationProgress {
  const InitializationProgress({
    required this.dependencies,
    required this.repositories,
    required this.environmentStore,
  });

  /// Mutable version of dependencies
  final Dependencies dependencies;

  /// Repositories
  final Repositories repositories;

  /// Environment store
  final EnvironmentStore environmentStore;
}
