import 'package:base_starter/src/features/auth/data/data_source/interface/auth/auth_data_source.dart';
import 'package:base_starter/src/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockAuthDataSource extends Mock implements IAuthDataSource {}

void main() {
  group('AuthRepository', () {
    late _MockAuthDataSource dataSource;
    late AuthRepository repository;

    setUp(() {
      dataSource = _MockAuthDataSource();
      repository = AuthRepository(dataSource: dataSource);
    });

    group('maps RestClientException subtypes to AppException', () {
      test('ConnectionException becomes NetworkException '
          'preserving cause and status code', () async {
        const cause = 'socket-offline';
        when(() => dataSource.login(email: 'a@b.c', password: 'pw')).thenThrow(
          const ConnectionException(
            message: 'no connection',
            statusCode: 503,
            cause: cause,
          ),
        );

        try {
          await repository.login(email: 'a@b.c', password: 'pw');
          fail('Expected a NetworkException');
        } on NetworkException catch (e, st) {
          check(e.message).equals('no connection');
          check(e.statusCode).equals(503);
          check(e.cause).equals(cause);
          check(st.toString()).isNotEmpty();
        }
      });

      test('RequestTimeoutException becomes TimeoutAppException', () async {
        when(
          () => dataSource.login(email: 'a@b.c', password: 'pw'),
        ).thenThrow(const RequestTimeoutException(message: 'too slow'));

        await check(
          repository.login(email: 'a@b.c', password: 'pw'),
        ).throws<TimeoutAppException>(
          (e) => e.has((it) => it.message, 'message').equals('too slow'),
        );
      });

      test('WrongResponseTypeException becomes ParseException', () async {
        when(
          () => dataSource.login(email: 'a@b.c', password: 'pw'),
        ).thenThrow(const WrongResponseTypeException(message: 'bad shape'));

        await check(
          repository.login(email: 'a@b.c', password: 'pw'),
        ).throws<ParseException>(
          (e) => e.has((it) => it.message, 'message').equals('bad shape'),
        );
      });

      test('ClientException becomes NetworkException '
          'because it is a responseless client-side failure', () async {
        const cause = 'request cancelled';
        when(
          () => dataSource.login(email: 'a@b.c', password: 'pw'),
        ).thenThrow(const ClientException(message: 'cancelled', cause: cause));

        await check(
          repository.login(email: 'a@b.c', password: 'pw'),
        ).throws<NetworkException>(
          (e) => e
            ..has((it) => it.message, 'message').equals('cancelled')
            ..has((it) => it.cause, 'cause').equals(cause),
        );
      });

      test('CustomBackendException becomes BackendException '
          'so the UI keeps the backend payload', () async {
        const backend = CustomBackendException(
          message: 'invalid credentials',
          error: {'code': 'AUTH_001'},
          statusCode: 400,
        );
        when(
          () => dataSource.login(email: 'a@b.c', password: 'pw'),
        ).thenThrow(backend);

        await check(
          repository.login(email: 'a@b.c', password: 'pw'),
        ).throws<BackendException>(
          (e) => e
            ..has((it) => it.message, 'message').equals('invalid credentials')
            ..has((it) => it.error, 'error').deepEquals({'code': 'AUTH_001'})
            ..has((it) => it.statusCode, 'statusCode').equals(400),
        );
      });
    });

    test('returns the token pair when login succeeds', () async {
      const tokens = TokenPair(access: 'a', refresh: 'r');
      when(
        () => dataSource.login(email: 'a@b.c', password: 'pw'),
      ).thenAnswer((_) async => tokens);

      check(
        await repository.login(email: 'a@b.c', password: 'pw'),
      ).equals(tokens);
    });
  });
}
