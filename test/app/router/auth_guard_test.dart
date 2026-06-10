import 'package:base_starter/src/app/router/guards/auth_guard.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yx_navigation/yx_navigation.dart';

RouteNode _treeTo(YxRoute? destination) => const YxRoute(
  id: 'app',
).toNode(children: [if (destination != null) destination.toNode()]);

YxRoute? _topOf(GuardResult result) => switch (result) {
  GuardResultRedirect(:final target) =>
    target.children.isEmpty ? null : target.children.last.route,
  _ => null,
};

void main() {
  group('AuthGuard', () {
    final origin = _treeTo(AppRoutes.splash);

    GuardResult run({
      required bool authenticated,
      required YxRoute? destination,
    }) => AuthGuard(
      isAuthenticated: () => authenticated,
    ).call(origin, _treeTo(destination), GuardContext());

    test('redirects unauthenticated user away from a protected route', () {
      final result = run(authenticated: false, destination: AppRoutes.root);

      check(result).isA<GuardResultRedirect>();
      check(_topOf(result)).equals(AppRoutes.auth);
    });

    test('lets an unauthenticated user reach the auth screen', () {
      final result = run(authenticated: false, destination: AppRoutes.auth);

      check(result).isA<GuardResultNext>();
    });

    test('lets an unauthenticated user stay on splash', () {
      final result = run(authenticated: false, destination: AppRoutes.splash);

      check(result).isA<GuardResultNext>();
    });

    test('redirects an authenticated user off the auth screen to root', () {
      final result = run(authenticated: true, destination: AppRoutes.auth);

      check(result).isA<GuardResultRedirect>();
      check(_topOf(result)).equals(AppRoutes.root);
    });

    test('lets an authenticated user reach the root shell', () {
      final result = run(authenticated: true, destination: AppRoutes.root);

      check(result).isA<GuardResultNext>();
    });

    test('treats an empty tree as the auth zone', () {
      final result = run(authenticated: false, destination: null);

      check(result).isA<GuardResultNext>();
    });
  });
}
