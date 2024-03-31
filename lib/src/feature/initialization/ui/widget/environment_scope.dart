import 'package:base_starter/src/feature/initialization/logic/base_config.dart';
import 'package:flutter/material.dart';

/// `EnvironmentScope` is an entry point to the environment scope.
class EnvironmentScope extends InheritedWidget {
  final BaseConfig config;

  const EnvironmentScope({
    required this.config,
    required super.child,
    super.key,
  });

  static BaseConfig of(BuildContext context) {
    final EnvironmentScope? wrapper =
        context.dependOnInheritedWidgetOfExactType<EnvironmentScope>();
    if (wrapper != null) {
      return wrapper.config;
    }
    throw Exception('No EnvironmentScope found in widget tree');
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

extension EnvironmentScopeExtension on BuildContext {
  BaseConfig get config => EnvironmentScope.of(this);
}
