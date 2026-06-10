import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';

extension RestClientExceptionMapper on RestClientException {
  /// Translates a transport-level [RestClientException] into a
  /// feature-meaningful [AppException] for the repository boundary.
  ///
  /// [CustomBackendException] and the other unmapped subtypes are returned
  /// unchanged because the presentation layer needs the backend payload.
  Object toAppException() => switch (this) {
    ConnectionException(:final message, :final cause, :final statusCode) =>
      NetworkException(message: message, cause: cause, statusCode: statusCode),
    RequestTimeoutException(:final message, :final cause) =>
      TimeoutAppException(message: message, cause: cause),
    WrongResponseTypeException(:final message) => ParseException(
      message: message,
    ),
    CustomBackendException() => this,
    ClientException() => this,
    InternalServerException() => this,
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
