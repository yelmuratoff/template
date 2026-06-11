import 'dart:async';

import 'package:base_starter/src/features/auth/presentation/auth_scope.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('AuthScope', () {
    late _MockAuthBloc authBloc;
    late StreamController<AuthState> states;

    setUp(() {
      authBloc = _MockAuthBloc();
      states = StreamController<AuthState>.broadcast();
      when(() => authBloc.stream).thenAnswer((_) => states.stream);
      when(() => authBloc.state).thenReturn(const InitialAuthState());
    });

    tearDown(() => states.close());

    Widget host(Widget child) => MaterialApp(
      home: AuthScope(authBloc: authBloc, child: child),
    );

    Widget stateProbe() => Builder(
      builder: (context) => Text('${AuthScope.stateOf(context).runtimeType}'),
    );

    testWidgets('exposes the current auth state to descendants', (
      tester,
    ) async {
      when(() => authBloc.state).thenReturn(const AuthenticatedAuthState());

      await tester.pumpWidget(host(stateProbe()));

      expect(find.text('AuthenticatedAuthState'), findsOneWidget);
    });

    testWidgets('rebuilds dependents when the auth state changes', (
      tester,
    ) async {
      await tester.pumpWidget(host(stateProbe()));
      expect(find.text('InitialAuthState'), findsOneWidget);

      when(() => authBloc.state).thenReturn(const UnauthenticatedAuthState());
      states.add(const UnauthenticatedAuthState());
      await tester.pump();

      expect(find.text('UnauthenticatedAuthState'), findsOneWidget);
    });

    testWidgets('login dispatches a LoginAuthEvent to the bloc', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => AuthScope.of(
                context,
                listen: false,
              ).login(email: 'john@mail.com', password: 'changeme'),
              child: const Text('login'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('login'));

      verify(
        () => authBloc.add(
          const LoginAuthEvent(email: 'john@mail.com', password: 'changeme'),
        ),
      ).called(1);
    });

    testWidgets('logout dispatches a LogoutAuthEvent to the bloc', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => AuthScope.of(context, listen: false).logout(),
              child: const Text('logout'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('logout'));

      verify(() => authBloc.add(const LogoutAuthEvent())).called(1);
    });
  });
}
