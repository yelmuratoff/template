import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/app/ui/widget/material_context.dart';
import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/services/router_service.dart';
import 'package:base_starter/src/features/initialization/logic/base_config.dart';
import 'package:base_starter/src/features/initialization/model/dependencies.dart';
import 'package:base_starter/src/features/initialization/model/environment.dart';
import 'package:base_starter/src/features/initialization/ui/widget/dependencies_scope.dart';
import 'package:base_starter/src/features/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/features/settings/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispect/ispect.dart';

/// [App] is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by [MaterialApp]
/// ([Directionality], [MediaQuery], [Localizations]) should be placed here.

class App extends StatefulWidget {
  const App({required this.result, super.key});

  @override
  State<App> createState() => _AppState();

  /// The initialization result from the `InitializationProcessor`
  /// which contains initialized dependencies.
  final InitializationResult result;

  /// Running this function will result in attaching
  /// corresponding [RenderObject] to the root of the tree.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }
}

class _AppState extends State<App> {
  late final GoRouter _router;
  String? _environmentKey;

  @override
  void initState() {
    _router = createRouter;
    talkerWrapper.good('📱 App started');
    talkerWrapper.route(_router.configuration.debugKnownRoutes());

    _router.routerDelegate.addListener(_handleRouteInformation);

    _environmentKey = widget.result.dependencies.sharedPreferences
        .getString(Preferences.environment);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _router.routerDelegate.removeListener(_handleRouteInformation);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => widget.result.dependencies.authBloc,
          ),
        ],
        child: EnvironmentScope(
          config:
              configMap[_environmentKey] ?? configMap[Environment.prod.value]!,
          child: DependenciesScope(
            dependencies: widget.result.dependencies,
            repositories: widget.result.repositories,
            child: SettingsScope(
              settingsBloc: widget.result.dependencies.settingsBloc,
              child: MaterialContext(
                routerConfig: _router,
              ),
            ),
          ),
        ),
      );

  /// Handles the route information and logs it
  void _handleRouteInformation() {
    final RouteMatchList routeMatchList =
        _router.routerDelegate.currentConfiguration;

    final RouteConfiguration configuration = _router.configuration;

    final GoRouterState state =
        routeMatchList.last.buildState(configuration, routeMatchList);

    final screenName = routeMatchList.last.route.name;
    final path = routeMatchList.last.matchedLocation;
    final pathParams = routeMatchList.pathParameters;
    final queryParams = state.uri.queryParameters;
    final extra = state.extra;

    RouterService.setRoute(path);

    talkerWrapper.route(
      "📍 Route: \n Name: $screenName \n Path: $path \n Path parameters: $pathParams \n Query parameters: $queryParams \n Extra params: $extra",
    );
  }
}
