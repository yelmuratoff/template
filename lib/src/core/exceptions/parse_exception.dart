part of 'app_exception.dart';

/// The payload was received but could not be decoded into the expected shape.
final class ParseException extends AppException {
  const ParseException({required this.message, this.cause}) : super(message);

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}
