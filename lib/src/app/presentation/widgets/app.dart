import 'package:base_starter/src/app/presentation/widgets/material_context.dart';
import 'package:base_starter/src/features/auth/presentation/auth_scope.dart';
import 'package:base_starter/src/features/auth/presentation/user_scope.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/initialization/presentation/dependencies_scope.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';

/// `App` is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by `MaterialApp`
/// (`Directionality`, `MediaQuery`, `Localizations`) should be placed here.
class App extends StatelessWidget {
  const App({required this.result, super.key});

  /// The initialization result from `CompositionRoot.compose()`
  /// which contains initialized dependencies.
  final CompositionResult result;

  @override
  Widget build(BuildContext context) => DependenciesScope(
    dependencies: result.dependencies,
    repositories: result.repositories,
    child: SettingsScope(
      settingsBloc: result.dependencies.settingsBloc,
      child: AuthScope(
        authBloc: result.dependencies.authBloc,
        child: UserScope(
          userBloc: result.dependencies.userBloc,
          child: const MaterialContext(),
        ),
      ),
    ),
  );
}
