import 'package:base_starter/src/app/presentation/widget/material_context.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/di/dependencies_scope.dart';
import 'package:base_starter/src/features/auth/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/initialization/logic/composition_root.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';
import 'package:octopus/octopus.dart';

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
  final _router = Octopus(
    routes: Routes.values,
    defaultRoute: Routes.auth,
    observers: [
      ISpectNavigatorObserver(),
    ],
  );

  @override
  void initState() {
    super.initState();

    final routes = _router.config.routes
        .map((key, value) => MapEntry(key, value.toString()));

    ISpect.route('📜 Routes:\n${AppUtils.formatPrettyJson(routes)}');

    context.blocRead<UserCubit>().get();
  }

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
          child: MaterialContext(
            routerConfig: _router.config,
          ),
        ),
      );
}
