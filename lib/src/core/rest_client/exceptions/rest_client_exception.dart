// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all rest client exceptions.
///
/// Sealed so the repository-boundary mapper switches exhaustively over every
/// subtype — adding a new one is a compile error until it is handled.
@immutable
sealed class RestClientException extends Equatable implements Exception {
  const RestClientException({
    required this.message,
    this.cause,
    this.statusCode,
  });

  /// Message of the exception
  final String message;

  /// The status code of the response (if any)
  final int? statusCode;

  /// The cause of the exception
  /// It is the inner exception that caused this exception to be thrown
  final Object? cause;
}

/// [ClientException] is thrown if something went wrong on client side
final class ClientException extends RestClientException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      '''ClientException('
      'message: $message,'
      'statusCode: $statusCode,'
      'cause: $cause'
      ')''';

  @override
  List<Object?> get props => [message, statusCode, cause];
}

/// [CustomBackendException] is thrown if the backend returns an error

final class CustomBackendException extends RestClientException {
  const CustomBackendException({
    required super.message,
    required this.error,
    super.statusCode,
  });

  /// The error returned by the backend
  final Map<String, Object?> error;

  @override
  String toString() =>
      '''CustomBackendException('
      'message: $message,'
      'error: $error,'
      'statusCode: $statusCode,'
      ')''';

  @override
  List<Object?> get props => [message, error, statusCode];
}

/// [WrongResponseTypeException] is thrown if the response type
/// is not the expected one

final class WrongResponseTypeException extends RestClientException {
  const WrongResponseTypeException({required super.message, super.statusCode});

  @override
  String toString() =>
      '''WrongResponseTypeException('
      'message: $message,'
      'statusCode: $statusCode,'
      ')''';

  @override
  List<Object?> get props => [message, statusCode];
}

/// [RequestTimeoutException] is thrown when the request exceeded a
/// connect/send/receive timeout — distinct from [ConnectionException] so the
/// repository layer can map it to the app-level timeout type.
final class RequestTimeoutException extends RestClientException {
  const RequestTimeoutException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      '''RequestTimeoutException('
      'message: $message,'
      'statusCode: $statusCode,'
      'cause: $cause'
      ')''';

  @override
  List<Object?> get props => [message, statusCode, cause];
}

/// [ConnectionException] is thrown if there are problems with the connection

final class ConnectionException extends RestClientException {
  const ConnectionException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      '''ConnectionException('
      'message: $message,'
      'statusCode: $statusCode,'
      'cause: $cause'
      ')''';

  @override
  List<Object?> get props => [message, statusCode, cause];
}

/// If something went wrong on the server side

final class InternalServerException extends RestClientException {
  const InternalServerException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      '''InternalServerException('
      'message: $message,'
      'statusCode: $statusCode,'
      'cause: $cause'
      ')''';

  @override
  List<Object?> get props => [message, statusCode, cause];
}
