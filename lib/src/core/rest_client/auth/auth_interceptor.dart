import 'dart:async';

import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/auth/token_storage.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:dio/dio.dart';
import 'package:ispect/ispect.dart';

/// Attaches the access token to every request and transparently refreshes it
/// when the backend answers 401.
///
/// Invariants:
/// - N concurrent 401s produce exactly one refresh call: [QueuedInterceptor]
///   serializes error handling, and follow-up 401s detect that the stored
///   token already rotated and reuse it instead of refreshing again.
/// - Every original request is retried at most once; a 401 on the retry
///   revokes the session.
/// - A 401/403 from the refresh endpoint itself revokes the session: tokens
///   are cleared (so [TokenStorage.changes] emits `null`) and the original
///   error is propagated with a [RevokedTokenException] cause.
/// - A network failure during refresh does NOT revoke the session — flaky
///   connectivity must never sign the user out.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStorage,
    required this._plainDio,
    this._refreshPath = '/auth/refresh',
  });

  final TokenStorage _tokenStorage;

  /// Bare client without this interceptor: used for the refresh call (no
  /// recursion) and the single retry (no second refresh for the same request).
  final Dio _plainDio;

  final String _refreshPath;

  static const _authHeader = 'Authorization';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    TokenPair? pair;
    try {
      pair = await _tokenStorage.read();
    } on CacheException {
      // Already logged by the storage layer; an unreadable token store must
      // not block the request — it proceeds unauthenticated.
      pair = null;
    }
    if (pair != null) {
      options.headers[_authHeader] = 'Bearer ${pair.access}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    final TokenPair fresh;
    try {
      fresh = await _refresh(
        staleHeader: err.requestOptions.headers[_authHeader] as String?,
      );
    } on RevokedTokenException catch (e) {
      return handler.next(_withCause(err, e));
    } on DioException {
      return handler.next(err);
    }

    try {
      final response = await _plainDio.fetch<Object?>(
        err.requestOptions..headers[_authHeader] = 'Bearer ${fresh.access}',
      );
      handler.resolve(response);
    } on DioException catch (retryErr) {
      if (retryErr.response?.statusCode == 401) {
        await _revoke(cause: retryErr);
        return handler.next(
          _withCause(err, RevokedTokenException(cause: retryErr)),
        );
      }
      handler.next(retryErr);
    }
  }

  /// Throws [RevokedTokenException] when the session cannot be restored and
  /// rethrows the [DioException] on transport failures.
  Future<TokenPair> _refresh({required String? staleHeader}) async {
    final current = await _read();
    if (current == null) {
      throw const RevokedTokenException(cause: 'No stored token pair');
    }

    final staleAccess = staleHeader?.replaceFirst('Bearer ', '');
    if (staleAccess != null && current.access != staleAccess) {
      // An earlier 401 in the queue already rotated the pair.
      return current;
    }

    try {
      final response = await _plainDio.post<Map<String, dynamic>>(
        _refreshPath,
        data: {'token': current.refresh},
      );
      final data = response.data;
      if (data == null) {
        throw const RevokedTokenException(cause: 'Empty refresh response');
      }
      final fresh = TokenPair.fromJson(data);
      await _tokenStorage.save(fresh);
      return fresh;
    } on DioException catch (e, st) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _revoke(cause: e);
        Error.throwWithStackTrace(RevokedTokenException(cause: e), st);
      }
      rethrow;
    }
  }

  Future<TokenPair?> _read() async {
    try {
      return await _tokenStorage.read();
    } on CacheException {
      return null;
    }
  }

  Future<void> _revoke({required Object cause}) async {
    ISpect.logger.handle(
      exception: RevokedTokenException(cause: cause),
      stackTrace: StackTrace.current,
      message: 'Session revoked, clearing tokens',
    );
    try {
      await _tokenStorage.clear();
    } on CacheException {
      // Logged by the storage layer; revocation still propagates to callers.
    }
  }

  DioException _withCause(DioException err, Object cause) => DioException(
    requestOptions: err.requestOptions,
    response: err.response,
    type: err.type,
    error: cause,
    message: err.message,
  );
}
