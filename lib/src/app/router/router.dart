// ignore_for_file: prefer_expression_function_bodies

import 'package:base_starter/src/app/presentation/page/root.dart';
import 'package:base_starter/src/app/router/extras.dart';
import 'package:base_starter/src/common/presentation/pages/error_router_page.dart';
import 'package:base_starter/src/features/auth/presentation/auth.dart';
import 'package:base_starter/src/features/home/presentation/home.dart';
import 'package:base_starter/src/features/initialization/presentation/page/splash.dart';
import 'package:base_starter/src/features/profile/presentation/profile.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ispect/ispect.dart';

export 'package:go_router/go_router.dart';

/// This line declares a global key variable which is used to access the
/// `NavigatorState` object associated with a widget.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// This key is used to access the `NavigatorState` object associated with
/// the home section of the app.
final GlobalKey<NavigatorState> _homeSectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeSectionNavigatorKey');

final GlobalKey<NavigatorState> _profileSectionNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profileSectionNavigatorKey');

/// This function returns a [CustomTransitionPage] widget with default
/// fade animation.
CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required GoRouterState state,
  required Widget child,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

String? getCurrentPath() {
  if (navigatorKey.currentContext != null) {
    final routerDelegate =
        GoRouter.of(navigatorKey.currentContext!).routerDelegate;
    final lastMatch = routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final location = matchList.uri.toString();
    return location;
  } else {
    return null;
  }
}

/// This function returns a [NoTransitionPage] widget with no animation.
CustomTransitionPage<T> buildPageWithNoTransition<T>({
  required GoRouterState state,
  required Widget child,
}) =>
    NoTransitionPage<T>(
      key: state.pageKey,
      child: child,
    );

/// This function returns a dynamic [Page] widget based on the input parameters.
/// It uses the '[buildPageWithDefaultTransition]' function to create a page
/// with a default [fade animation].
Page<dynamic> Function(GoRouterState state) defaultPageBuilder<T>(
  Widget child,
) =>
    (state) => buildPageWithDefaultTransition<T>(
          state: state,
          child: child,
        );

/// [createRouter] is a factory function that creates a [GoRouter] instance
/// with all routes.

GoRouter createRouter = GoRouter(
  initialLocation: SplashPage.routePath,
  navigatorKey: navigatorKey,
  observers: [
    HeroController(),
    ISpectNavigatorObserver(
      isLogModals: false,
    ),
  ],
  errorBuilder: (_, state) {
    final error = state.matchedLocation;
    return RouterErrorPage(
      error: error,
    );
  },
  routes: [
    GoRoute(
      name: SplashPage.name,
      path: SplashPage.routePath,
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      name: AuthPage.name,
      path: AuthPage.routePath,
      builder: (_, __) => const AuthPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (
        _,
        __,
        navigationShell,
      ) {
        /// Return the widget that implements the custom shell (in this case
        /// using a BottomNavigationBar). The StatefulNavigationShell is passed
        /// to be able access the state of the shell and to navigate to other
        /// branches in a stateful way.
        return RootPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeSectionNavigatorKey,
          observers: [
            HeroController(),
            ISpectNavigatorObserver(
              isLogModals: false,
            ),
          ],
          routes: [
            GoRoute(
              name: HomePage.name,
              path: HomePage.routePath,
              builder: (_, __) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileSectionNavigatorKey,
          routes: [
            GoRoute(
              name: ProfilePage.name,
              path: ProfilePage.routePath,
              builder: (_, __) => const ProfilePage(),
              routes: [
                GoRoute(
                  name: SettingsPage.name,
                  path: SettingsPage.routePath,
                  builder: (_, state) {
                    final queryParameters = state.uri.queryParameters;
                    return SettingsPage(
                      title: queryParameters[ExtraKeys.title] ?? 'Settings',
                    );
                  },
                ),
              ],
            ),
          ],
          observers: [
            HeroController(),
            ISpectNavigatorObserver(
              isLogModals: false,
            ),
          ],
        ),
      ],
    ),
  ],
);
