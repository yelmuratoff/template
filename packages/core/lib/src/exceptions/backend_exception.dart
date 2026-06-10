part of 'app_exception.dart';

/// The backend rejected the request with a structured error.
///
/// A known, recoverable failure (e.g. invalid credentials or a 5xx): the
/// repository maps every backend-origin transport failure into this so the
/// BLoC handles one family without a transport type leaking past the data
/// layer. [error] carries the backend payload the presentation layer surfaces.
final class BackendException extends AppException {
  const BackendException({
    required this.message,
    this.error = const {},
    this.statusCode,
    this.cause,
  }) : super(message);

  final String message;
  final Map<String, Object?> error;
  final int? statusCode;
  final Object? cause;

  @override
  List<Object?> get props => [message, error, statusCode, cause];
}
