import 'package:base_starter/src/features/initialization/containers/dependencies.dart';
import 'package:base_starter/src/features/initialization/containers/repositories.dart';
import 'package:base_starter/src/features/initialization/factories/dependencies_factories.dart';
import 'package:base_starter/src/features/initialization/factories/repositories_factories.dart';
import 'package:clock/clock.dart';
import 'package:ispect/ispect.dart';

/// A place where all dependencies are initialized.
///
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
///
/// It is a good practice to keep all dependencies in one place to make it
/// easier to manage them and to ensure that they are initialized only once.

final class CompositionRoot {
  const CompositionRoot();

  /// Composes dependencies and returns result of composition.
  Future<CompositionResult> compose() async {
    final stopwatch = clock.stopwatch()..start();

    ISpect.info('🌀 Initializing dependencies...');

    // initialize dependencies
    final dependencies = await const DependenciesFactory().create();

    // initialize repositories
    final repositories = await RepositoriesFactory(
      restClient: dependencies.restClient,
    ).create();

    stopwatch.stop();
    final result = CompositionResult(
      dependencies: dependencies,
      repositories: repositories,
      millisecondsSpent: stopwatch.elapsedMilliseconds,
    );

    ISpect.good('Dependencies initialized:\n$result');

    return result;
  }
}

/// Result of composition
final class CompositionResult {
  const CompositionResult({
    required this.dependencies,
    required this.repositories,
    required this.millisecondsSpent,
  });

  /// The dependencies container
  final DependenciesContainer dependencies;

  /// The repositories container
  final RepositoriesContainer repositories;

  /// The number of milliseconds spent
  final int millisecondsSpent;

  @override
  String toString() => '$CompositionResult('
      '\ndependencies: $dependencies, '
      '\nrepositories: $repositories, '
      '\nmillisecondsSpent: $millisecondsSpent'
      ')';
}

/// Factory that creates an instance of [T].
abstract class Factory<T> {
  const Factory();

  /// Creates an instance of [T].
  T create();
}

/// Factory that creates an instance of [T] asynchronously.
abstract class AsyncFactory<T> {
  const AsyncFactory();

  /// Creates an instance of [T].
  Future<T> create();
}
