part of 'initialization_processor.dart';

/// Factory for creating pre-initialized objects.
abstract class InitializationFactory {
  /// Get the environment store.
  EnvironmentStore getEnvironmentStore();
}

mixin InitializationFactoryImpl implements InitializationFactory {
  @override
  EnvironmentStore getEnvironmentStore() => const EnvironmentStore();
}
