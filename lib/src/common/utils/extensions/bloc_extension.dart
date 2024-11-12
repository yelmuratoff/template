import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocExceptionHandlerExtension<T> on BlocBase<T> {
  void handleException({
    required Object? exception,
    required StackTrace? stackTrace,
    required void Function(
      String message,
      Object? cause,
      int? statusCode,
    ) onError,
  }) {
    if (exception is RestClientException) {
      onError(
        exception.message,
        exception.cause,
        exception.statusCode,
      );
    } else {
      onError(
        exception.toString(),
        exception,
        null,
      );
    }
  }
}
