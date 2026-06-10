import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';

extension RestClientExceptionMapper on RestClientException {
  /// Translates a transport-level [RestClientException] into a
  /// feature-meaningful [AppException] for the repository boundary.
  ///
  /// [CustomBackendException] and any other unmapped subtype are returned
  /// unchanged because the presentation layer needs the backend payload.
  Object toAppException() => switch (this) {
    ConnectionException(:final message, :final cause, :final statusCode) =>
      NetworkException(message: message, cause: cause, statusCode: statusCode),
    RequestTimeoutException(:final message, :final cause) =>
      TimeoutAppException(message: message, cause: cause),
    WrongResponseTypeException(:final message) => ParseException(
      message: message,
    ),
    _ => this,
  };
}
