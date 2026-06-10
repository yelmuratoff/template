import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rest_client/rest_client.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockDio extends Mock implements Dio {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  const stale = TokenPair(access: 'stale-access', refresh: 'stale-refresh');
  const fresh = TokenPair(access: 'fresh-access', refresh: 'fresh-refresh');

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '/')),
    );
    registerFallbackValue(
      Response<Object?>(requestOptions: RequestOptions(path: '/')),
    );
  });

  group('AuthInterceptor', () {
    late _MockTokenStorage tokenStorage;
    late _MockDio plainDio;
    late AuthInterceptor interceptor;

    setUp(() {
      tokenStorage = _MockTokenStorage();
      plainDio = _MockDio();
      interceptor = AuthInterceptor(
        tokenStorage: tokenStorage,
        plainDio: plainDio,
      );
    });

    RequestOptions requestWith({String? access}) {
      final options = RequestOptions(path: '/orders');
      if (access != null) {
        options.headers['Authorization'] = 'Bearer $access';
      }
      return options;
    }

    DioException unauthorized(RequestOptions options) => DioException(
      requestOptions: options,
      response: Response<Object?>(requestOptions: options, statusCode: 401),
    );

    void stubRefreshSuccess() {
      when(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any<Object?>(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 200,
          data: fresh.toJson(),
        ),
      );
      when(() => tokenStorage.save(fresh)).thenAnswer((_) async {});
    }

    void stubRetrySuccess() {
      when(() => plainDio.fetch<Object?>(any())).thenAnswer(
        (invocation) async => Response<Object?>(
          requestOptions:
              invocation.positionalArguments.first as RequestOptions,
          statusCode: 200,
        ),
      );
    }

    test('attaches the bearer token to outgoing requests', () async {
      when(() => tokenStorage.read()).thenAnswer((_) async => stale);
      final options = RequestOptions(path: '/orders');
      final handler = _MockRequestHandler();

      await interceptor.onRequest(options, handler);

      check(options.headers['Authorization']).equals('Bearer ${stale.access}');
      verify(() => handler.next(options)).called(1);
    });

    test(
      'proceeds unauthenticated when the token store is unreadable',
      () async {
        when(
          () => tokenStorage.read(),
        ).thenThrow(const CacheException(message: 'broken store'));
        final options = RequestOptions(path: '/orders');
        final handler = _MockRequestHandler();

        await interceptor.onRequest(options, handler);

        check(options.headers).not((it) => it.containsKey('Authorization'));
        verify(() => handler.next(options)).called(1);
      },
    );

    test('refreshes once and retries with the new token on 401', () async {
      when(() => tokenStorage.read()).thenAnswer((_) async => stale);
      stubRefreshSuccess();
      stubRetrySuccess();
      final options = requestWith(access: stale.access);
      final handler = _MockErrorHandler();

      await interceptor.onError(unauthorized(options), handler);

      verify(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'token': stale.refresh},
        ),
      ).called(1);
      verify(() => tokenStorage.save(fresh)).called(1);
      check(options.headers['Authorization']).equals('Bearer ${fresh.access}');
      verify(() => handler.resolve(any())).called(1);
    });

    test('refreshes exactly once for three sequentially queued 401s '
        'carrying the same stale token', () async {
      // QueuedInterceptor serializes onError; emulate the queue by invoking
      // the handler sequentially the way Dio would.
      var stored = stale;
      when(() => tokenStorage.read()).thenAnswer((_) async => stored);
      when(() => tokenStorage.save(fresh)).thenAnswer((_) async {
        stored = fresh;
      });
      when(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any<Object?>(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 200,
          data: fresh.toJson(),
        ),
      );
      stubRetrySuccess();

      for (var i = 0; i < 3; i++) {
        final handler = _MockErrorHandler();
        await interceptor.onError(
          unauthorized(requestWith(access: stale.access)),
          handler,
        );
        verify(() => handler.resolve(any())).called(1);
      }

      verify(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any<Object?>(named: 'data'),
        ),
      ).called(1);
      verify(() => plainDio.fetch<Object?>(any())).called(3);
    });

    test(
      'revokes the session when the retried request is rejected again',
      () async {
        when(() => tokenStorage.read()).thenAnswer((_) async => stale);
        when(() => tokenStorage.clear()).thenAnswer((_) async {});
        stubRefreshSuccess();
        when(() => plainDio.fetch<Object?>(any())).thenAnswer((invocation) {
          final options =
              invocation.positionalArguments.first as RequestOptions;
          throw unauthorized(options);
        });
        final handler = _MockErrorHandler();

        await interceptor.onError(
          unauthorized(requestWith(access: stale.access)),
          handler,
        );

        verify(() => tokenStorage.clear()).called(1);
        final forwarded =
            verify(() => handler.next(captureAny())).captured.single
                as DioException;
        check(forwarded.error).isA<RevokedTokenException>();
        // Exactly one refresh attempt for the original request.
        verify(
          () => plainDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any<Object?>(named: 'data'),
          ),
        ).called(1);
      },
    );

    test('clears tokens and propagates RevokedTokenException '
        'when the refresh endpoint rejects the refresh token', () async {
      when(() => tokenStorage.read()).thenAnswer((_) async => stale);
      when(() => tokenStorage.clear()).thenAnswer((_) async {});
      when(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any<Object?>(named: 'data'),
        ),
      ).thenAnswer((_) {
        final options = RequestOptions(path: '/auth/refresh');
        throw DioException(
          requestOptions: options,
          response: Response<Object?>(requestOptions: options, statusCode: 401),
        );
      });
      final handler = _MockErrorHandler();

      await interceptor.onError(
        unauthorized(requestWith(access: stale.access)),
        handler,
      );

      verify(() => tokenStorage.clear()).called(1);
      final forwarded =
          verify(() => handler.next(captureAny())).captured.single
              as DioException;
      check(forwarded.error).isA<RevokedTokenException>();
    });

    test('keeps the session when the refresh call fails with '
        'a transport error', () async {
      when(() => tokenStorage.read()).thenAnswer((_) async => stale);
      when(
        () => plainDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: any<Object?>(named: 'data'),
        ),
      ).thenAnswer((_) {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          type: DioExceptionType.connectionError,
        );
      });
      final original = unauthorized(requestWith(access: stale.access));
      final handler = _MockErrorHandler();

      await interceptor.onError(original, handler);

      verifyNever(() => tokenStorage.clear());
      verify(() => handler.next(original)).called(1);
    });

    test('forwards non-401 errors untouched', () async {
      final options = requestWith(access: stale.access);
      final error = DioException(
        requestOptions: options,
        response: Response<Object?>(requestOptions: options, statusCode: 500),
      );
      final handler = _MockErrorHandler();

      await interceptor.onError(error, handler);

      verify(() => handler.next(error)).called(1);
      verifyNever(() => tokenStorage.read());
    });
  });
}
