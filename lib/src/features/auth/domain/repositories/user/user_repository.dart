import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/exceptions/rest_client_exception.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IUserRepository {
  /// Reads the locally cached user without hitting the network.
  ///
  /// A corrupt cached value is reset and reported as `null`, not thrown.
  /// Throws [CacheException] only if the underlying storage read itself fails.
  UserDTO? getCachedUser();

  /// Fetches the user from the backend and refreshes the local cache.
  ///
  /// Throws [NetworkException], [TimeoutAppException] or [ParseException]
  /// depending on the transport failure; [CustomBackendException] (or another
  /// unmapped [RestClientException]) when the backend rejects the request;
  /// [CacheException] if writing the refreshed value to disk fails.
  Future<UserDTO?> getFreshUser();

  /// Clears the locally cached user.
  ///
  /// Throws [CacheException] if the underlying storage delete fails.
  Future<void> clearCache();
}
