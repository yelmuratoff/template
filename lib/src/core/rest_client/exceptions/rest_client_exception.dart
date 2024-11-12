// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for all rest client exceptions
@immutable
abstract base class RestClientException extends Equatable implements Exception {
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
  String toString() => '''ClientException('
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
  String toString() => '''CustomBackendException('
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
  const WrongResponseTypeException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => '''WrongResponseTypeException('
      'message: $message,'
      'statusCode: $statusCode,'
      ')''';

  @override
  List<Object?> get props => [message, statusCode];
}

/// [ConnectionException] is thrown if there are problems with the connection

final class ConnectionException extends RestClientException {
  const ConnectionException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() => '''ConnectionException('
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
  String toString() => '''InternalServerException('
      'message: $message,'
      'statusCode: $statusCode,'
      'cause: $cause'
      ')''';

  @override
  List<Object?> get props => [message, statusCode, cause];
}
