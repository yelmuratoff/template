import 'package:base_starter/src/app/presentation/widgets/material_context.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/presentation/dependencies_scope.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';

/// `App` is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by `MaterialApp`
/// (`Directionality`, `MediaQuery`, `Localizations`) should be placed here.

class App extends StatefulWidget {
  const App({required this.result, super.key});

  @override
  State<App> createState() => _AppState();

  /// The initialization result from the `InitializationProcessor`
  /// which contains initialized dependencies.
  final CompositionResult result;

  /// Running this function will result in attaching
  /// corresponding `RenderObject` to the root of the tree.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }
}

class _AppState extends State<App> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DependenciesScope(
        dependencies: widget.result.dependencies,
        repositories: widget.result.repositories,
        child: SettingsScope(
          settingsBloc: widget.result.dependencies.settingsBloc,
          child: const MaterialContext(),
        ),
      );
}
