import 'package:yx_navigation/yx_navigation.dart';

/// Stable route identities for the application navigation tree.
///
/// Each [YxRoute] is a lightweight key that ties a tree node back to its
/// declaration in `AppRouterSchema`. Ids are lowercase `kebab-case` so they
/// serialize cleanly into deep-link URIs.
abstract final class AppRoutes {
  const AppRoutes._();

  /// Session-restore screen shown while the auth status check resolves.
  static const splash = YxRoute(id: 'splash');

  /// Unauthenticated entry point.
  static const auth = YxRoute(id: 'auth');

  /// Authenticated shell: the `IndexedStack` tab container.
  static const root = YxRoute(id: 'root');

  /// Home tab outlet (hosts [home]).
  static const homeTab = YxRoute(id: 'home-tab');

  /// Profile tab outlet (hosts [profile] and pushes [settings]).
  static const profileTab = YxRoute(id: 'profile-tab');

  /// Home tab landing page.
  static const home = YxRoute(id: 'home');

  /// Profile tab landing page.
  static const profile = YxRoute(id: 'profile');

  /// Settings page, pushed onto the profile tab stack.
  static const settings = YxRoute(id: 'settings');
}
