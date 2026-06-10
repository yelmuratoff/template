import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';

abstract interface class IUserRepository {
  /// Reads the locally cached user without hitting the network.
  ///
  /// Throws [CacheException] if the cached payload cannot be read or decoded.
  UserDTO? getCachedUser();

  /// Fetches the user from the backend and refreshes the local cache.
  ///
  /// Throws [NetworkException], [TimeoutAppException] or [ParseException]
  /// depending on the transport failure, [CacheException] if writing the
  /// refreshed value to disk fails.
  Future<UserDTO?> getFreshUser();

  /// Clears the locally cached user.
  ///
  /// Throws [CacheException] if the underlying storage delete fails.
  Future<void> clearCache();
}
