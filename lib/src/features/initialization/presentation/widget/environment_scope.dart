import 'package:base_starter/src/features/initialization/logic/base_config.dart';
import 'package:flutter/material.dart';

/// `InternalEnvironmentScope` is an entry point to the environment scope.
class InternalEnvironmentScope extends InheritedWidget {
  final InternalEnvConfig config;

  const InternalEnvironmentScope({
    required this.config,
    required super.child,
    super.key,
  });

  static InternalEnvConfig of(BuildContext context) {
    final InternalEnvironmentScope? wrapper =
        context.dependOnInheritedWidgetOfExactType<InternalEnvironmentScope>();
    if (wrapper != null) {
      return wrapper.config;
    }
    throw Exception('No InternalEnvironmentScope found in widget tree');
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
