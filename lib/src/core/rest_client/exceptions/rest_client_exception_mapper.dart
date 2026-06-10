import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';

extension RestClientExceptionMapper on RestClientException {
  /// Translates a transport-level [RestClientException] into a
  /// feature-meaningful [AppException] for the repository boundary.
  ///
  /// The mapping is total: every subtype becomes an [AppException], so no
  /// transport type leaks past the data layer. A backend rejection carrying a
  /// structured payload ([CustomBackendException]) becomes a [BackendException]
  /// that keeps the payload for the UI; a responseless client-side failure
  /// ([ClientException] — cancelled, bad certificate, encode/decode error)
  /// becomes a [NetworkException].
  AppException toAppException() => switch (this) {
    ConnectionException(:final message, :final cause, :final statusCode) =>
      NetworkException(message: message, cause: cause, statusCode: statusCode),
    RequestTimeoutException(:final message, :final cause) =>
      TimeoutAppException(message: message, cause: cause),
    WrongResponseTypeException(:final message) => ParseException(
      message: message,
    ),
    CustomBackendException(:final message, :final error, :final statusCode) =>
      BackendException(message: message, error: error, statusCode: statusCode),
    ClientException(:final message, :final statusCode, :final cause) =>
      NetworkException(message: message, cause: cause, statusCode: statusCode),
  };
}

/// Runs [action] at a repository boundary, re-typing any
/// [RestClientException] into the matching [AppException] via
/// [RestClientExceptionMapper.toAppException] while preserving the stack.
///
/// Use it only inside repositories: that is the one layer responsible for
/// translating transport failures. Calling it from a BLoC or a datasource
/// smears the layer boundaries.
///
/// The transport layer (dio interceptors) already logs the failure, so this
/// only re-types it — it must not log again.
Future<T> mapRestErrors<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on RestClientException catch (e, st) {
    Error.throwWithStackTrace(e.toAppException(), st);
  }
}
