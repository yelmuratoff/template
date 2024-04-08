import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/app/ui/widget/material_context.dart';
import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/services/router_service.dart';
import 'package:base_starter/src/feature/initialization/logic/base_config.dart';
import 'package:base_starter/src/feature/initialization/model/dependencies.dart';
import 'package:base_starter/src/feature/initialization/model/environment.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/dependencies_scope.dart';
import 'package:base_starter/src/feature/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
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
  final ISpectController controller = ISpectController();
  late final GoRouter _router;
  String? _environmentKey;

  @override
  void initState() {
    _router = createRouter;
    talkerWrapper.good(message: '📱 App started');
    talkerWrapper.route(
      message: _router.configuration.debugKnownRoutes(),
    );
    _router.routerDelegate.addListener(() {
      final String location =
          _router.routerDelegate.currentConfiguration.last.matchedLocation;
      routerService.setRoute(location);
      talkerWrapper.route(
        message: location,
      );
    });
    _environmentKey = widget.result.dependencies.sharedPreferences
        .getString(Preferences.environment);
    super.initState();
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
                controller: controller,
              ),
            ),
          ),
        ),
      );
}
