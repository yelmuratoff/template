import 'package:base_starter/src/features/auth/data/data_source/interface/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/remote_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/data/repositories/user/user_repository.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockRemoteDataSource extends Mock implements IRemoteUserDataSource {}

class _MockLocalDataSource extends Mock implements ILocalUserDataSource {}

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

  group('UserRepository', () {
    late _MockRemoteDataSource remoteDataSource;
    late _MockLocalDataSource localDataSource;
    late UserRepository repository;

    setUp(() {
      remoteDataSource = _MockRemoteDataSource();
      localDataSource = _MockLocalDataSource();
      repository = UserRepository(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
      registerFallbackValue(cachedUser);
    });

    test('getCachedUser reads the local cache without hitting the network', () {
      when(localDataSource.get).thenReturn(cachedUser);

      check(repository.getCachedUser()).equals(cachedUser);
      verifyNever(() => remoteDataSource.get());
    });

    test(
      'getFreshUser fetches the remote user and writes it to the cache',
      () async {
        when(() => remoteDataSource.get()).thenAnswer((_) async => freshUser);
        when(
          () => localDataSource.write(user: any(named: 'user')),
        ).thenAnswer((_) async {});

        check(await repository.getFreshUser()).equals(freshUser);
        verify(() => localDataSource.write(user: freshUser)).called(1);
      },
    );

    test('getFreshUser maps a transport failure to an AppException', () async {
      when(
        () => remoteDataSource.get(),
      ).thenThrow(const ConnectionException(message: 'offline'));

      await check(repository.getFreshUser()).throws<NetworkException>();
      verifyNever(() => localDataSource.write(user: any(named: 'user')));
    });

    test('getCachedUser surfaces a storage failure as CacheException', () {
      when(
        localDataSource.get,
      ).thenThrow(const CacheException(message: 'keychain unavailable'));

      check(repository.getCachedUser).throws<CacheException>();
    });

    test('clearCache delegates to the local data source', () async {
      when(localDataSource.clear).thenAnswer((_) async {});

      await repository.clearCache();

      verify(localDataSource.clear).called(1);
    });
  });
}
