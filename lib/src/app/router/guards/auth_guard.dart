import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:yx_navigation/yx_navigation.dart';

/// Redirect-based auth guard for the top-level navigation tree.
///
/// Runs on every mutation and inspects the top-level destination (the last
/// child of the tree root):
///
/// * unauthenticated and heading anywhere but [AppRoutes.auth]/[AppRoutes.splash]
///   → redirect to [AppRoutes.auth];
/// * authenticated and heading to [AppRoutes.auth] → redirect to
///   [AppRoutes.root].
///
/// [isAuthenticated] is a closure over the current auth state, keeping the
/// guard pure-Dart and unit-testable. Reactive re-evaluation on login/revoke
/// is driven imperatively by `NavigationManager`, which re-runs this pipeline
/// whenever it switches the top-level route.
final class AuthGuard implements RouteNodeGuard {
  const AuthGuard({required this.isAuthenticated});

  /// Reports whether a session is currently active.
  final bool Function() isAuthenticated;

  @override
  GuardResult call(RouteNode origin, RouteNode target, GuardContext context) {
    final destination = target.children.isEmpty
        ? null
        : target.children.last.route;

    final inAuthZone =
        destination == null ||
        destination == AppRoutes.auth ||
        destination == AppRoutes.splash;

    if (!isAuthenticated() && !inAuthZone) {
      return GuardResult.redirect(
        target: target.copyWith(children: [AppRoutes.auth.toNode()]),
      );
    }

    if (isAuthenticated() && destination == AppRoutes.auth) {
      return GuardResult.redirect(
        target: target.copyWith(children: [AppRoutes.root.toNode()]),
      );
    }

    return const GuardResult.next();
  }
}
