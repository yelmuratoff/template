import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/initialization/models/repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A widget which is responsible for providing the dependencies.
class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    required this.repositories,
    super.key,
  });

  /// The dependencies
  final DependenciesContainer dependencies;

  /// The repositories
  final RepositoriesContainer repositories;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  /// Get the repositories from the [context].
  static RepositoriesContainer repositoriesOf(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).repositories;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<DependenciesContainer>(
          'dependencies',
          dependencies,
        ),
      )
      ..add(
        DiagnosticsProperty<RepositoriesContainer>(
          'repositories',
          repositories,
        ),
      );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
