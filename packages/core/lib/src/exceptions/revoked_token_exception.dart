part of 'app_exception.dart';

/// The refresh token is no longer accepted by the backend: the session is
/// over and the user must sign in again.
final class RevokedTokenException extends AppException {
  const RevokedTokenException({this.cause}) : super('Session revoked');

  final Object? cause;

  @override
  List<Object?> get props => [cause];
}
