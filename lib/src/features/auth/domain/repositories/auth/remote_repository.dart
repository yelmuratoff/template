import 'package:core/core.dart';
import 'package:rest_client/rest_client.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IAuthRepository {
  /// Authenticates with [email] and [password] and returns the token pair.
  ///
  /// Throws [NetworkException] if connectivity is unavailable.
  /// Throws [TimeoutAppException] if the request exceeds its time budget.
  /// Throws [ParseException] if the response cannot be decoded.
  /// Throws [BackendException] when the backend rejects the request (e.g.
  /// invalid credentials); its payload is preserved for the UI.
  Future<TokenPair?> login({required String email, required String password});

  /// Fetches the authenticated user's profile.
  ///
  /// Throws [NetworkException] if connectivity is unavailable.
  /// Throws [TimeoutAppException] if the request exceeds its time budget.
  /// Throws [ParseException] if the response cannot be decoded.
  /// Throws [BackendException] when the backend rejects the request; its
  /// payload is preserved for the UI.
  Future<UserDTO> getCurrentUser();
}
