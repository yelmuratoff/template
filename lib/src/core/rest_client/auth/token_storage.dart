import 'dart:async';
import 'dart:convert';

import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/secure_storage.dart';
import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:ispect/ispect.dart';

/// Persistent storage for the session [TokenPair].
///
/// The only place tokens live; backed by encrypted-at-rest storage.
abstract interface class TokenStorage {
  /// Returns the stored pair, or `null` when the user is signed out.
  ///
  /// Throws [CacheException] if the underlying storage fails.
  Future<TokenPair?> read();

  /// Throws [CacheException] if the underlying storage fails.
  Future<void> save(TokenPair pair);

  /// Removes the pair. Emits `null` on [changes]: the session is over.
  ///
  /// Throws [CacheException] if the underlying storage fails.
  Future<void> clear();

  /// Emits the new pair on every [save] and `null` on every [clear],
  /// letting auth state react to revocation without polling.
  Stream<TokenPair?> get changes;

  /// Closes the [changes] stream.
  Future<void> dispose();
}

/// [TokenStorage] on top of [SecureStorage].
final class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({required SecureStorage storage}) : _storage = storage;

  final SecureStorage _storage;
  final _changes = StreamController<TokenPair?>.broadcast();

  @override
  Stream<TokenPair?> get changes => _changes.stream;

  @override
  Future<TokenPair?> read() async {
    final raw = await _storage.read(key: Preferences.tokenPair);
    if (raw == null) return null;
    try {
      return TokenPair.fromJson(json.decode(raw) as Map<String, dynamic>);
      // A corrupt persisted value (interrupted write, schema drift) must not
      // brick every launch: reset the entry and treat the user as signed out.
    } on Object catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Stored token pair is corrupt, resetting',
      );
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(TokenPair pair) async {
    await _storage.write(
      key: Preferences.tokenPair,
      value: json.encode(pair.toJson()),
    );
    _changes.add(pair);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: Preferences.tokenPair);
    _changes.add(null);
  }

  @override
  Future<void> dispose() => _changes.close();
}
