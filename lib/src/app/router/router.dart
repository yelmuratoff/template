// ignore_for_file: prefer_expression_function_bodies

import 'package:base_starter/src/app/ui/page/root.dart';
import 'package:base_starter/src/common/ui/pages/error_router_page.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/auth/ui/page/auth.dart';
import 'package:base_starter/src/feature/home/ui/page/home.dart';
import 'package:base_starter/src/feature/initialization/ui/page/splash.dart';
import 'package:base_starter/src/feature/inspector/inspector_page.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

export 'package:go_router/go_router.dart';

/// This function returns a [CustomTransitionPage] widget with default fade animation.
CustomTransitionPage<T> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) =>
    CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );

String? getCurrentPath() {
  if (navigatorKey.currentContext != null) {
    final GoRouterDelegate routerDelegate =
        GoRouter.of(navigatorKey.currentContext!).routerDelegate;
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  } else {
    return null;
  }
}

/// This function returns a [NoTransitionPage] widget with no animation.

CustomTransitionPage<T> buildPageWithNoTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) =>
    NoTransitionPage<T>(
      key: state.pageKey,
      child: child,
    );

/// This function returns a dynamic [Page] widget based on the input parameters.
/// It uses the '[buildPageWithDefaultTransition]' function to create a page with a default [fade animation].

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
  Widget child,
) =>
    (BuildContext context, GoRouterState state) =>
        buildPageWithDefaultTransition<T>(
          context: context,
          state: state,
          child: child,
        );

/// [createRouter] is a factory function that creates a [GoRouter] instance with all routes.

GoRouter createRouter() => GoRouter(
      initialLocation: SplashPage.routePath,
      navigatorKey: navigatorKey,
      observers: [
        TalkerRouteObserver(talker),
        HeroController(),
      ],
      errorPageBuilder: (context, state) {
        final error = state.matchedLocation;
        return CupertinoPage(
          child: RouterErrorPage(
            error: error,
          ),
        );
      },
      routes: [
        GoRoute(
          name: SplashPage.name,
          path: SplashPage.routePath,
          pageBuilder: (context, pathParameters) => const CupertinoPage(
            child: SplashPage(),
          ),
        ),
        GoRoute(
          name: AuthPage.name,
          path: AuthPage.routePath,
          pageBuilder: (context, pathParameters) => const CupertinoPage(
            child: AuthPage(),
          ),
        ),
        StatefulShellRoute.indexedStack(
          pageBuilder: (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            /// Return the widget that implements the custom shell (in this case
            /// using a BottomNavigationBar). The StatefulNavigationShell is passed
            /// to be able access the state of the shell and to navigate to other
            /// branches in a stateful way.
            return CupertinoPage(
              child: RootPage(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: rootPageNavigatorKey,
              routes: [
                GoRoute(
                  name: HomePage.name,
                  path: HomePage.routePath,
                  pageBuilder: (context, pathParameters) => const CupertinoPage(
                    child: HomePage(),
                  ),
                  routes: [
                    GoRoute(
                      name: SettingsPage.name,
                      path: SettingsPage.routePath,
                      pageBuilder: (context, pathParameters) =>
                          const CupertinoPage(
                        child: SettingsPage(),
                      ),
                    ),
                    GoRoute(
                      name: InspectorPage.name,
                      path: InspectorPage.routePath,
                      pageBuilder: (context, pathParameters) {
                        final Map<String, dynamic>? args =
                            pathParameters.extra as Map<String, dynamic>?;
                        return CupertinoPage(
                          child: InspectorPage(
                            appBarTitle:
                                args?[InspectorPage.paramTitle] as String?,
                            theme: args?[InspectorPage.paramTheme]
                                    as TalkerScreenTheme? ??
                                TalkerScreenTheme(
                                  backgroundColor:
                                      context.theme.colorScheme.background,
                                  textColor: context.colors.text,
                                  cardColor: context.colors.card,
                                ),
                            itemsBuilder: args?[InspectorPage.paramItemBuilder]
                                as Widget Function(BuildContext, TalkerData)?,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
