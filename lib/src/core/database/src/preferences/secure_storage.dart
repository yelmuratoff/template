import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ispect/ispect.dart';

/// Encrypted-at-rest key-value storage for secrets, tokens and credentials.
///
/// Throws [CacheException] from every method if the platform storage fails.
abstract interface class SecureStorage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});

  Future<void> deleteAll();
}

/// [SecureStorage] backed by [FlutterSecureStorage]
/// (Keychain on iOS, encrypted preferences on Android).
final class FlutterSecureStorageWrapper implements SecureStorage {
  const FlutterSecureStorageWrapper({required this._storage});

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) =>
      _guard(() => _storage.read(key: key), operation: 'read "$key"');

  @override
  Future<void> write({required String key, required String value}) => _guard(
    () => _storage.write(key: key, value: value),
    operation: 'write "$key"',
  );

  @override
  Future<void> delete({required String key}) =>
      _guard(() => _storage.delete(key: key), operation: 'delete "$key"');

  @override
  Future<void> deleteAll() => _guard(_storage.deleteAll, operation: 'wipe');

  Future<T> _guard<T>(
    Future<T> Function() action, {
    required String operation,
  }) async {
    try {
      return await action();
    } on Exception catch (e, st) {
      final message = 'Secure storage $operation failed';
      ISpect.logger.handle(exception: e, stackTrace: st, message: message);
      Error.throwWithStackTrace(CacheException(message: message, cause: e), st);
    }
  }
}
