import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() => registerFallbackValue(Options()));

  group('RestClientDio', () {
    late _MockDio dio;
    late RestClientDio client;

    setUp(() {
      dio = _MockDio();
      client = RestClientDio(baseUrl: 'https://example.test', dio: dio);
    });

    test('a programming error surfaces unchanged instead of as a network '
        'failure', () async {
      when(
        () => dio.request<Object>(
          any(),
          data: any<Object?>(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(StateError('bug'));

      await check(client.get('/orders')).throws<StateError>();
    });

    test('a revoked session surfaces as RevokedTokenException rather than '
        'the 401 body', () async {
      final options = RequestOptions(path: '/orders');
      when(
        () => dio.request<Object>(
          any(),
          data: any<Object?>(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: options,
          response: Response<Object?>(
            requestOptions: options,
            statusCode: 401,
            data: {'message': 'Unauthorized'},
          ),
          error: const RevokedTokenException(cause: 'refresh rejected'),
        ),
      );

      await check(client.get('/orders')).throws<RevokedTokenException>();
    });
  });
}
