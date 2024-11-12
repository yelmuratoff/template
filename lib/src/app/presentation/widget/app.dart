import 'package:base_starter/src/app/presentation/widget/material_context.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/services/router_service.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/di/dependencies_scope.dart';
import 'package:base_starter/src/features/auth/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/initialization/models/dependencies.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';

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
  final InitializationResult result;

  /// Running this function will result in attaching
  /// corresponding `RenderObject` to the root of the tree.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter;

    ISpect.route('📜 ${_router.configuration.debugKnownRoutes()}');

    _router.routerDelegate.addListener(_handleRouteInformation);

    context.blocRead<UserCubit>().get();
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_handleRouteInformation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DependenciesScope(
        dependencies: widget.result.dependencies,
        repositories: widget.result.repositories,
        child: SettingsScope(
          settingsBloc: widget.result.dependencies.settingsBloc,
          child: MaterialContext(
            routerConfig: _router,
          ),
        ),
      );

  /// Handles the route information and logs it
  void _handleRouteInformation() {
    final routeMatchList = _router.routerDelegate.currentConfiguration;

    final path = routeMatchList.last.matchedLocation;

    RouterService.setRoute(path);
  }
}
