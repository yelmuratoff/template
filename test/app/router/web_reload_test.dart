import 'dart:async';

import 'package:base_starter/src/app/router/app_router_schema.dart';
import 'package:base_starter/src/app/router/navigation_manager.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/logic/session_restore.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';
import 'package:yx_navigation/yx_navigation.dart';

class _MockAuthRepository extends Mock implements IAuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockUserBloc extends Mock implements UserBloc {}

void main() {
  final reloadedUrl = AppRouterSchema.serialization.convert(
    const YxRoute(id: 'app').toNode(
      children: [
        AppRoutes.root.toNode(
          children: [
            AppRoutes.homeTab.toNode(children: [AppRoutes.home.toNode()]),
            AppRoutes.profileTab.toNode(
              children: [
                AppRoutes.profile.toNode(),
                AppRoutes.settings.toNode(),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  group('web reload of a signed-in session', () {
    late _MockTokenStorage tokenStorage;
    late StreamController<TokenPair?> changes;
    late AuthBloc authBloc;
    late NavigationManager manager;

    YxRoute topOf(NavigationManager m) =>
        m.stateManager.state.children.last.route;

    void restoreUrl() => manager.stateManager.mutate(
      (_) => AppRouterSchema.serialization.parse(reloadedUrl),
    );

    setUp(() {
      tokenStorage = _MockTokenStorage();
      changes = StreamController<TokenPair?>.broadcast();
      when(() => tokenStorage.changes).thenAnswer((_) => changes.stream);
      when(tokenStorage.read).thenAnswer(
        (_) async => const TokenPair(access: 'access', refresh: 'refresh'),
      );
      authBloc = AuthBloc(
        repository: _MockAuthRepository(),
        tokenStorage: tokenStorage,
      );
      manager = NavigationManager(
        authBloc: authBloc,
        userBloc: _MockUserBloc(),
      );
    });

    tearDown(() async {
      await manager.dispose();
      await authBloc.close();
      await changes.close();
    });

    test('lands on sign-in when the URL is restored before the session', () {
      restoreUrl();

      check(topOf(manager)).equals(AppRoutes.auth);
    });

    test('opens the shell once the session is restored', () async {
      await restoreSession(authBloc);

      check(topOf(manager)).equals(AppRoutes.root);
    });

    test('keeps the restored tab and its stack after the session', () async {
      await restoreSession(authBloc);
      restoreUrl();

      final state = manager.stateManager.state;
      check(topOf(manager)).equals(AppRoutes.root);
      check(
        state.findByRoute(AppRoutes.root)!.children.last.route,
      ).equals(AppRoutes.profileTab);
      check(state.findByRoute(AppRoutes.settings)).isNotNull();
    });
  });
}
