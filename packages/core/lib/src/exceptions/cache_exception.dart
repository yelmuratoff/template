part of 'app_exception.dart';

/// A local storage read/write failed (preferences, secure storage, database).
final class CacheException extends AppException {
  const CacheException({required this.message, this.cause}) : super(message);

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}
