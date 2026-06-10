import 'package:base_starter/src/app/presentation/screens/root_screen.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/features/auth/presentation/auth_screen.dart';
import 'package:base_starter/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:base_starter/src/features/home/presentation/home_screen.dart';
import 'package:base_starter/src/features/initialization/presentation/page/splash.dart';
import 'package:base_starter/src/features/profile/presentation/profile_screen.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yx_navigation/yx_navigation.dart';
import 'package:yx_navigation_flutter/yx_navigation_flutter.dart';

/// Maps every [AppRoutes] entry to its widget for the router's resolver.
///
/// The guard pipeline (auth gating, tab synchronization) lives in
/// `NavigationManager`, which owns the injected `RouteNodeStateManager`. This
/// schema therefore declares widgets only — its declaration-level guards are
/// not wired when a state manager is injected via `build`.
base class AppRouterSchema extends RouterSchema {
  AppRouterSchema();

  @override
  List<RouteDeclaration> get declarations => [
    RouteDeclaration.routeBuilder(
      route: AppRoutes.splash,
      routeBuilder: RouteBuilder.widget(
        builder: (context, node) => const SplashScreen(),
      ),
    ),
    RouteDeclaration.routeBuilder(
      route: AppRoutes.auth,
      routeBuilder: RouteBuilder.widget(
        builder: (context, node) => const AuthScreen(),
      ),
    ),
    RouteDeclaration.indexedStack(
      route: AppRoutes.root,
      routeBuilder: RouteIndexedStackBuilder(
        indexedBuilder: (context, node, indexedStack, controller) =>
            RootView(controller: controller, child: indexedStack),
      ),
      declarations: [_homeTabDeclaration, _profileTabDeclaration],
    ),
  ];

  /// Injected state manager supplies the initial tree, so this is unused.
  @override
  RouteNode initialNodeBuilder(MutableRouteNode node) => node;
}

final _homeTabDeclaration = RouteDeclaration.routeBuilder(
  route: AppRoutes.homeTab,
  routeBuilder: RouteBuilder.outlet(
    outletBuilder: (context, node, outlet) => outlet,
  ),
  declarations: [
    RouteDeclaration.routeBuilder(
      route: AppRoutes.home,
      routeBuilder: RouteBuilder.widget(
        builder: (context, node) => BlocProvider(
          create: (_) => CounterCubit(),
          child: const HomeScreen(),
        ),
      ),
    ),
  ],
);

final _profileTabDeclaration = RouteDeclaration.routeBuilder(
  route: AppRoutes.profileTab,
  routeBuilder: RouteBuilder.outlet(
    outletBuilder: (context, node, outlet) => outlet,
  ),
  declarations: [
    RouteDeclaration.routeBuilder(
      route: AppRoutes.profile,
      routeBuilder: RouteBuilder.widget(
        builder: (context, node) => const ProfileScreen(),
      ),
    ),
    RouteDeclaration.routeBuilder(
      route: AppRoutes.settings,
      routeBuilder: RouteBuilder.widget(
        builder: (context, node) => const SettingsScreen(),
      ),
    ),
  ],
);
