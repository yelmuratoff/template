import 'dart:async';

import 'package:base_starter/src/app/router/guards/auth_guard.dart';
import 'package:base_starter/src/app/router/guards/tab_init_guard.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:yx_navigation/yx_navigation.dart';

/// Owns the root [RouteNodeStateManager] and translates auth-state changes into
/// context-free navigation.
///
/// The guard pipeline is built from routes alone (auth gating, indexed-stack
/// tab sync, tab seeding), so the schema only needs to map routes to widgets.
/// A subscription to [AuthBloc] drives the top-level transitions: login lands
/// on [AppRoutes.root] and triggers the user fetch, while logout or a revoked
/// session lands on [AppRoutes.auth] — closing the revoke loop without a
/// `BuildContext`.
final class NavigationManager {
  NavigationManager({required AuthBloc authBloc, required this._userBloc})
    : _authBloc = authBloc,
      stateManager = RouteNodeStateManager(
        routeNode: _container.toNode(children: [AppRoutes.splash.toNode()]),
        routeNodeGuard: GuardConfiguration(
          redirectGuard: const RedirectRouteNodeGuard(),
          guards: [
            AuthGuard(
              isAuthenticated: () => authBloc.state is AuthenticatedAuthState,
            ),
            const NavigateToIndexedStackNodeGuard(
              route: AppRoutes.root,
              declaredRoutes: [AppRoutes.homeTab, AppRoutes.profileTab],
            ),
            const TabInitGuard(
              tabRoute: AppRoutes.homeTab,
              childRoute: AppRoutes.home,
            ),
            const TabInitGuard(
              tabRoute: AppRoutes.profileTab,
              childRoute: AppRoutes.profile,
            ),
          ],
        ),
      ) {
    _authSubscription = _authBloc.stream.listen(_onAuthStateChanged);
  }

  /// Implicit top-level container; the delegate renders its children as the
  /// root navigator's pages, so it needs no declaration of its own.
  static const _container = YxRoute(id: 'app');

  /// Root state manager driving the whole navigation tree.
  final RouteNodeStateManager stateManager;

  final AuthBloc _authBloc;
  final UserBloc _userBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  /// Swaps the top-level destination to the authenticated shell, opening on the
  /// home tab.
  ///
  /// The indexed stack treats its last child as the active tab; tab seeding
  /// appends in declaration order, leaving the profile tab last (active), so
  /// move the home tab to the end after the shell is seeded.
  void openRoot() => stateManager
    ..setChildren([AppRoutes.root.toNode()])
    ..mutate(
      (root) => root
        ..findByRoute(
          AppRoutes.root,
        )?.addOrMoveToEnd(AppRoutes.homeTab.toNode()),
    );

  /// Swaps the top-level destination to the sign-in screen.
  void openAuth() => stateManager.setChildren([AppRoutes.auth.toNode()]);

  /// Pushes settings onto the profile tab stack.
  void openSettings() => stateManager.mutate((root) {
    root.findByRoute(AppRoutes.profileTab)?.add(AppRoutes.settings.toNode());
    return root;
  });

  void _onAuthStateChanged(AuthState state) {
    switch (state) {
      case AuthenticatedAuthState():
        openRoot();
        _userBloc.add(const FetchUserEvent());
      case UnauthenticatedAuthState():
        openAuth();
      case InitialAuthState():
      case LoadingAuthState():
      case ErrorAuthState():
        break;
    }
  }

  /// Releases the auth subscription and the state manager.
  Future<void> dispose() async {
    await _authSubscription.cancel();
    await stateManager.close();
  }
}
