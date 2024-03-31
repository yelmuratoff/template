import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/feature/initialization/model/dependencies.dart';
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
  final Dependencies dependencies;

  /// The repositories
  final Repositories repositories;

  /// Get the dependencies from the [context].
  static Dependencies of(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  /// Get the repositories from the [context].
  static Repositories repositoriesOf(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).repositories;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Dependencies>('dependencies', dependencies),
    );
    properties.add(
      DiagnosticsProperty<Repositories>('repositories', repositories),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
