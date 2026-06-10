import 'dart:async';

import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:base_starter/src/features/auth/presentation/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserBloc extends Mock implements UserBloc {}

void main() {
  const user = UserDTO(
    id: 1,
    email: 'a@b.c',
    name: 'Ann',
    role: 'admin',
    avatar: 'url',
    creationAt: '2024',
    updatedAt: '2024',
  );

  group('UserScope', () {
    late _MockUserBloc userBloc;
    late StreamController<UserState> states;

    setUp(() {
      userBloc = _MockUserBloc();
      states = StreamController<UserState>.broadcast();
      when(() => userBloc.stream).thenAnswer((_) => states.stream);
      when(() => userBloc.state).thenReturn(const InitialUserState());
    });

    tearDown(() => states.close());

    Widget host(Widget child) => MaterialApp(
      home: UserScope(userBloc: userBloc, child: child),
    );

    testWidgets('userOf exposes the loaded user', (tester) async {
      when(() => userBloc.state).thenReturn(const LoadedUserState(user: user));

      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) =>
                Text(UserScope.userOf(context)?.name ?? 'none'),
          ),
        ),
      );

      expect(find.text('Ann'), findsOneWidget);
    });

    testWidgets('userOf is null when no user is loaded', (tester) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) =>
                Text(UserScope.userOf(context)?.name ?? 'none'),
          ),
        ),
      );

      expect(find.text('none'), findsOneWidget);
    });

    testWidgets('fetch dispatches a FetchUserEvent to the bloc', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => UserScope.of(context, listen: false).fetch(),
              child: const Text('fetch'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('fetch'));

      verify(() => userBloc.add(const FetchUserEvent())).called(1);
    });
  });
}
