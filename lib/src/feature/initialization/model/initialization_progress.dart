import 'package:base_starter/src/feature/initialization/model/dependencies.dart';
import 'package:base_starter/src/feature/initialization/model/environment_store.dart';

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
