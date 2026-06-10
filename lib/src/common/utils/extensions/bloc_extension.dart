import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispect/ispect.dart';

extension BlocExceptionHandlerExtension<T> on BlocBase<T> {
  /// Routes a caught exception to [onError] with a normalized
  /// `(message, cause, statusCode)` triple.
  ///
  /// This is the recovery boundary where a failure becomes a UI state, so it
  /// logs every caught exception exactly once via [ISpect.logger]. The data
  /// layer that re-types and rethrows the exception stays silent to avoid
  /// duplicate log entries for one failure.
  void handleException({
    required Object? exception,
    required StackTrace? stackTrace,
    required void Function(String message, Object? cause, int? statusCode)
    onError,
  }) {
    ISpect.logger.handle(
      exception: exception ?? 'Unknown null exception',
      stackTrace: stackTrace,
      message: 'Handled exception in BLoC.',
    );
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
        BackendException(:final message, :final cause, :final statusCode) => (
          message,
          cause,
          statusCode,
        ),
        RevokedTokenException(:final cause) => ('Session revoked', cause, null),
        InvalidDataException() => (exception.toString(), exception, null),
        NoDataException() => (exception.toString(), exception, null),
      };
      onError(message, cause, statusCode);
    } else {
      onError(exception.toString(), exception, null);
    }
  }
}

extension BlocGuardExtension<State> on BlocBase<State> {
  /// Error boundary for event handlers: a known [AppException] becomes an
  /// error state, while an unexpected one is also reported as a programming
  /// bug.
  ///
  /// Every transport failure is mapped to an [AppException] at the repository
  /// (including a backend rejection, now a [BackendException]), so the known
  /// tier is a single family. The [Object] tier signals a bug: it is emitted
  /// as an error state and routed to [reportBug] (pass the BLoC's own
  /// `onError` so the observer reports it). The message/cause/statusCode are
  /// normalized by [handleException], which also logs the failure once.
  ///
  /// [body] is awaited so the handler does not return before its work
  /// finishes; an [emit] after the await would otherwise throw.
  Future<void> guard(
    Future<void> Function() body, {
    required Emitter<State> emit,
    required State Function(
      Object error,
      String message,
      Object? cause,
      int? statusCode,
    )
    errorState,
    required void Function(Object error, StackTrace stackTrace) reportBug,
  }) async {
    void emitError(Object e, StackTrace st) => handleException(
      exception: e,
      stackTrace: st,
      onError: (message, cause, statusCode) =>
          emit(errorState(e, message, cause, statusCode)),
    );

    try {
      await body();
    } on AppException catch (e, st) {
      emitError(e, st);
    } on Object catch (e, st) {
      emitError(e, st);
      reportBug(e, st);
    }
  }
}
