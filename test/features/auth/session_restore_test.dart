import 'dart:async';

import 'package:base_starter/src/features/auth/domain/repositories/auth/remote_repository.dart';
import 'package:base_starter/src/features/auth/logic/session_restore.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockAuthRepository extends Mock implements IAuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  const tokenPair = TokenPair(access: 'access', refresh: 'refresh');

  group('restoreSession', () {
    late _MockTokenStorage tokenStorage;
    late StreamController<TokenPair?> changes;
    late AuthBloc bloc;

    setUp(() {
      tokenStorage = _MockTokenStorage();
      changes = StreamController<TokenPair?>.broadcast();
      when(() => tokenStorage.changes).thenAnswer((_) => changes.stream);
      bloc = AuthBloc(
        repository: _MockAuthRepository(),
        tokenStorage: tokenStorage,
      );
    });

    tearDown(() async {
      await bloc.close();
      await changes.close();
    });

    test('resolves to signed in when a token pair is stored', () async {
      when(tokenStorage.read).thenAnswer((_) async => tokenPair);

      await restoreSession(bloc);

      check(bloc.state).isA<AuthenticatedAuthState>();
    });

    test('resolves to signed out when the store is empty', () async {
      when(tokenStorage.read).thenAnswer((_) async => null);

      await restoreSession(bloc);

      check(bloc.state).isA<UnauthenticatedAuthState>();
    });

    test('resolves to signed out when the token store fails', () async {
      when(
        tokenStorage.read,
      ).thenThrow(const CacheException(message: 'storage unavailable'));

      await restoreSession(bloc);

      check(bloc.state).isA<UnauthenticatedAuthState>();
    });

    test('does not complete before the session is resolved', () async {
      final read = Completer<TokenPair?>();
      when(tokenStorage.read).thenAnswer((_) => read.future);

      var resolved = false;
      unawaited(restoreSession(bloc).then((_) => resolved = true));
      await pumpEventQueue();

      check(resolved).isFalse();

      read.complete(tokenPair);
      await pumpEventQueue();

      check(resolved).isTrue();
    });
  });
}
