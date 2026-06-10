import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispect/ispect.dart';

extension BlocExceptionHandlerExtension<T> on BlocBase<T> {
  /// Routes a caught exception to [onError] with a normalized
  /// `(message, cause, statusCode)` triple.
  ///
  /// Known [AppException]s and [RestClientException]s carry their own message;
  /// anything else is an unexpected (programming) error, so it is reported to
  /// [ISpect.logger] before falling back to its `toString()`.
  void handleException({
    required Object? exception,
    required StackTrace? stackTrace,
    required void Function(String message, Object? cause, int? statusCode)
    onError,
  }) {
    if (exception is AppException) {
      final (message, cause, statusCode) = switch (exception) {
        NetworkException(:final message, :final cause, :final statusCode) => (
          message,
          cause,
          statusCode,
        ),
        TimeoutAppException(:final message, :final cause) => (
          message,
          cause,
          null,
        ),
        ParseException(:final message, :final cause) => (message, cause, null),
        CacheException(:final message, :final cause) => (message, cause, null),
        RevokedTokenException(:final cause) => ('Session revoked', cause, null),
        InvalidDataException() => (exception.toString(), exception, null),
        NoDataException() => (exception.toString(), exception, null),
      };
      onError(message, cause, statusCode);
    } else if (exception is RestClientException) {
      onError(exception.message, exception.cause, exception.statusCode);
    } else {
      ISpect.logger.handle(
        exception: exception ?? 'Unknown null exception',
        stackTrace: stackTrace,
        message: 'Unhandled exception in BLoC.',
      );
      onError(exception.toString(), exception, null);
    }
  }
}
