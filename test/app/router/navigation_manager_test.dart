import 'dart:async';

import 'package:base_starter/src/app/router/navigation_manager.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yx_navigation/yx_navigation.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

class _MockUserBloc extends Mock implements UserBloc {}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('NavigationManager', () {
    late _MockAuthBloc authBloc;
    late _MockUserBloc userBloc;
    late StreamController<AuthState> states;
    late NavigationManager manager;

    YxRoute? topOf(NavigationManager m) {
      final children = m.stateManager.state.children;
      return children.isEmpty ? null : children.last.route;
    }

    setUp(() {
      authBloc = _MockAuthBloc();
      userBloc = _MockUserBloc();
      states = StreamController<AuthState>.broadcast();

      when(() => authBloc.stream).thenAnswer((_) => states.stream);
      when(() => authBloc.state).thenReturn(const InitialAuthState());

      manager = NavigationManager(authBloc: authBloc, userBloc: userBloc);
    });

    tearDown(() async {
      await manager.dispose();
      await states.close();
    });

    test('starts on the splash screen', () {
      check(topOf(manager)).equals(AppRoutes.splash);
    });

    test(
      'authenticated state opens the root shell with both tabs seeded',
      () async {
        when(() => authBloc.state).thenReturn(const AuthenticatedAuthState());

        states.add(const AuthenticatedAuthState());
        await _settle();

        check(topOf(manager)).equals(AppRoutes.root);
        check(
          manager.stateManager.state.findByRoute(AppRoutes.home),
        ).isNotNull();
        check(
          manager.stateManager.state.findByRoute(AppRoutes.profile),
        ).isNotNull();
      },
    );

    test('authenticated state opens with the home tab active', () async {
      when(() => authBloc.state).thenReturn(const AuthenticatedAuthState());

      states.add(const AuthenticatedAuthState());
      await _settle();

      final rootNode = manager.stateManager.state.findByRoute(AppRoutes.root);
      check(rootNode).isNotNull();
      check(rootNode!.children.last.route).equals(AppRoutes.homeTab);
    });

    test('authenticated state triggers the user fetch', () async {
      when(() => authBloc.state).thenReturn(const AuthenticatedAuthState());

      states.add(const AuthenticatedAuthState());
      await _settle();

      verify(() => userBloc.add(const FetchUserEvent())).called(1);
    });

    test('unauthenticated state lands on the auth screen', () async {
      when(() => authBloc.state).thenReturn(const UnauthenticatedAuthState());

      states.add(const UnauthenticatedAuthState());
      await _settle();

      check(topOf(manager)).equals(AppRoutes.auth);
    });

    test('openSettings pushes settings onto the profile tab', () async {
      when(() => authBloc.state).thenReturn(const AuthenticatedAuthState());
      states.add(const AuthenticatedAuthState());
      await _settle();

      manager.openSettings();

      final profileTab = manager.stateManager.state.findByRoute(
        AppRoutes.profileTab,
      );
      check(profileTab).isNotNull();
      check(
        profileTab!.children.any((c) => c.route == AppRoutes.settings),
      ).isTrue();
    });
  });
}
