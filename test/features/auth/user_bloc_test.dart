import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/domain/repositories/user/user_repository.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_bloc.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements IUserRepository {}

void main() {
  const cachedUser = UserDTO(
    id: 1,
    email: 'a@b.c',
    name: 'Ann',
    role: 'admin',
    avatar: 'url',
    creationAt: '2024',
    updatedAt: '2024',
  );
  final freshUser = cachedUser.copyWith(name: 'Annie');

  group('UserBloc', () {
    late _MockUserRepository repository;

    setUp(() => repository = _MockUserRepository());

    UserBloc buildBloc() => UserBloc(userRepository: repository);

    Future<List<UserState>> recordStates(
      UserBloc bloc,
      void Function() act,
    ) async {
      final states = <UserState>[];
      final sub = bloc.stream.listen(states.add);
      act();
      await pumpEventQueue();
      await sub.cancel();
      return states;
    }

    test('emits the cached user, then the refreshed one', () async {
      when(repository.getCachedUser).thenReturn(cachedUser);
      when(repository.getFreshUser).thenAnswer((_) async => freshUser);

      final bloc = buildBloc();
      final states = await recordStates(
        bloc,
        () => bloc.add(const FetchUserEvent()),
      );

      check(states).deepEquals([
        const LoadedUserState(user: cachedUser),
        LoadedUserState(user: freshUser),
      ]);
      await bloc.close();
    });

    test(
      'keeps the cached user, then surfaces an error when refresh fails',
      () async {
        when(repository.getCachedUser).thenReturn(cachedUser);
        when(
          repository.getFreshUser,
        ).thenThrow(const NetworkException(message: 'offline'));

        final bloc = buildBloc();
        final states = await recordStates(
          bloc,
          () => bloc.add(const FetchUserEvent()),
        );

        check(states.first).isA<LoadedUserState>();
        check(states.last)
            .isA<ErrorUserState>()
            .has((s) => s.message, 'message')
            .equals('offline');
        await bloc.close();
      },
    );

    test('emits Loading then Loaded when no cache is present', () async {
      when(repository.getCachedUser).thenReturn(null);
      when(repository.getFreshUser).thenAnswer((_) async => freshUser);

      final bloc = buildBloc();
      final states = await recordStates(
        bloc,
        () => bloc.add(const FetchUserEvent()),
      );

      check(states).deepEquals([
        const LoadingUserState(),
        LoadedUserState(user: freshUser),
      ]);
      await bloc.close();
    });

    test('clear drops the cache and returns to the initial state', () async {
      when(repository.clearCache).thenAnswer((_) async {});

      final bloc = buildBloc();
      final states = await recordStates(
        bloc,
        () => bloc.add(const ClearUserEvent()),
      );

      check(states).deepEquals([const InitialUserState()]);
      verify(repository.clearCache).called(1);
      await bloc.close();
    });
  });
}
