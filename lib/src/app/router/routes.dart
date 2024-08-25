// ignore_for_file: avoid_unused_parameters
part of 'router.dart';

// <-- Splash Page -->

@TypedGoRoute<SplashRoute>(
  name: 'Splash',
  path: '/splash',
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

// <-- Auth Page -->

@TypedGoRoute<AuthRoute>(
  name: 'Auth',
  path: '/auth',
)
class AuthRoute extends GoRouteData {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthPage();
}

// <-- Statefull Shell Routes -->

@TypedStatefulShellRoute<RootShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<BranchHomeData>(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: '/home',
          name: 'Home',
        ),
      ],
    ),
    TypedStatefulShellBranch<BranchProfileData>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          name: 'Profile',
          routes: [
            TypedGoRoute<SettingsRoute>(
              path: 'settings',
              name: 'Settings',
            ),
          ],
        ),
      ],
    ),
  ],
)
class RootShellRouteData extends StatefulShellRouteData {
  const RootShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      RootPage(
        navigationShell: navigationShell,
      );
}

class BranchHomeData extends StatefulShellBranchData {
  const BranchHomeData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      _homeSectionNavigatorKey;

  static final List<NavigatorObserver> $observers = [
    HeroController(),
    ISpectNavigatorObserver(
      isLogModals: false,
    ),
  ];
}

class BranchProfileData extends StatefulShellBranchData {
  const BranchProfileData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      _profileSectionNavigatorKey;

  static final List<NavigatorObserver> $observers = [
    HeroController(),
    ISpectNavigatorObserver(
      isLogModals: false,
    ),
  ];

  static const List<GoRouteData> $routes = <GoRouteData>[
    ProfileRoute(),
  ];
}

// <-- Home Page -->

class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const List<GoRouteData> $routes = <GoRouteData>[
    ProfileRoute(),
  ];

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

// <-- Profile Page -->

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

// <-- Settings Page -->

class SettingsRoute extends GoRouteData {
  const SettingsRoute({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) => SettingsPage(
        title: title,
      );
}
