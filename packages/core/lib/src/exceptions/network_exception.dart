part of 'app_exception.dart';

/// Connectivity-level failure: the request never produced a usable response.
final class NetworkException extends AppException {
  const NetworkException({required this.message, this.cause, this.statusCode})
    : super(message);

  final String message;
  final Object? cause;
  final int? statusCode;

  @override
  List<Object?> get props => [message, cause, statusCode];
}
