import 'dart:async';

import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements IAuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  const tokenPair = TokenPair(access: 'access', refresh: 'refresh');

  setUpAll(() => registerFallbackValue(tokenPair));

  group('AuthBloc', () {
    late _MockAuthRepository repository;
    late _MockTokenStorage tokenStorage;
    late StreamController<TokenPair?> changes;

    setUp(() {
      repository = _MockAuthRepository();
      tokenStorage = _MockTokenStorage();
      changes = StreamController<TokenPair?>.broadcast();
      when(() => tokenStorage.changes).thenAnswer((_) => changes.stream);
    });

    tearDown(() => changes.close());

    AuthBloc buildBloc() =>
        AuthBloc(repository: repository, tokenStorage: tokenStorage);

    Future<List<AuthState>> recordStates(
      AuthBloc bloc,
      void Function() act,
    ) async {
      final states = <AuthState>[];
      final sub = bloc.stream.listen(states.add);
      act();
      await pumpEventQueue();
      await sub.cancel();
      return states;
    }

    test(
      'emits [Loading, Authenticated] and saves the pair on login',
      () async {
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tokenPair);
        when(() => tokenStorage.save(any())).thenAnswer((_) async {});

        final bloc = buildBloc();
        final states = await recordStates(
          bloc,
          () => bloc.add(
            const LoginAuthEvent(email: 'a@b.c', password: 'secret'),
          ),
        );

        check(states).deepEquals([
          const LoadingAuthState(),
          const AuthenticatedAuthState(),
        ]);
        verify(() => tokenStorage.save(tokenPair)).called(1);
        await bloc.close();
      },
    );

    test(
      'emits [Loading, Error] when login fails with a known failure',
      () async {
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const NetworkException(message: 'offline'));

        final bloc = buildBloc();
        final states = await recordStates(
          bloc,
          () => bloc.add(
            const LoginAuthEvent(email: 'a@b.c', password: 'secret'),
          ),
        );

        check(states.first).isA<LoadingAuthState>();
        check(states.last)
            .isA<ErrorAuthState>()
            .has((s) => s.message, 'message')
            .equals('offline');
        verifyNever(() => tokenStorage.save(any()));
        await bloc.close();
      },
    );

    test(
      'drops a second login while the first is in flight (droppable)',
      () async {
        final completer = Completer<TokenPair?>();
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => completer.future);
        when(() => tokenStorage.save(any())).thenAnswer((_) async {});

        final bloc = buildBloc();
        const event = LoginAuthEvent(email: 'a@b.c', password: 'secret');
        bloc
          ..add(event)
          ..add(event);
        await pumpEventQueue();
        completer.complete(tokenPair);
        await pumpEventQueue();

        verify(
          () => repository.login(email: 'a@b.c', password: 'secret'),
        ).called(1);
        await bloc.close();
      },
    );

    test(
      'emits [Loading, Authenticated] on check status when a token exists',
      () async {
        when(tokenStorage.read).thenAnswer((_) async => tokenPair);

        final bloc = buildBloc();
        final states = await recordStates(
          bloc,
          () => bloc.add(const CheckStatusAuthEvent()),
        );

        check(states).deepEquals([
          const LoadingAuthState(),
          const AuthenticatedAuthState(),
        ]);
        await bloc.close();
      },
    );

    test(
      'emits [Loading, Unauthenticated] on check status without a token',
      () async {
        when(tokenStorage.read).thenAnswer((_) async => null);

        final bloc = buildBloc();
        final states = await recordStates(
          bloc,
          () => bloc.add(const CheckStatusAuthEvent()),
        );

        check(states).deepEquals([
          const LoadingAuthState(),
          const UnauthenticatedAuthState(),
        ]);
        await bloc.close();
      },
    );

    test(
      'emits Unauthenticated when the session is revoked while authenticated',
      () async {
        when(tokenStorage.read).thenAnswer((_) async => tokenPair);

        final bloc = buildBloc();
        final states = <AuthState>[];
        final sub = bloc.stream.listen(states.add);

        bloc.add(const CheckStatusAuthEvent());
        await pumpEventQueue();
        check(states.last).isA<AuthenticatedAuthState>();

        changes.add(null);
        await pumpEventQueue();

        check(states.last).isA<UnauthenticatedAuthState>();
        await sub.cancel();
        await bloc.close();
      },
    );

    test('logout clears the token store and emits Unauthenticated', () async {
      when(tokenStorage.clear).thenAnswer((_) async {});

      final bloc = buildBloc();
      final states = await recordStates(
        bloc,
        () => bloc.add(const LogoutAuthEvent()),
      );

      check(states).deepEquals([
        const LoadingAuthState(),
        const UnauthenticatedAuthState(),
      ]);
      verify(tokenStorage.clear).called(1);
      await bloc.close();
    });
  });
}
