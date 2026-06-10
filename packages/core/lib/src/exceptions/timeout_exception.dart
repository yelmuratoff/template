part of 'app_exception.dart';

/// The request or its parsing exceeded the configured time budget.
final class TimeoutAppException extends AppException {
  const TimeoutAppException({required this.message, this.cause})
    : super(message);

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}
