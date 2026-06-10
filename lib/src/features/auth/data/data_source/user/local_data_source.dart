import 'dart:convert';

import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/database/src/preferences/preferences_dao.dart';
import 'package:base_starter/src/core/exceptions/app_exception.dart';
import 'package:base_starter/src/features/auth/data/data_source/interface/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:ispect/ispect.dart';

final class UserLocalDataSource extends PreferencesDao
    implements ILocalUserDataSource {
  const UserLocalDataSource({required super.sharedPreferences});

  PreferencesEntry<String> get _currentUserEntry =>
      stringEntry(Preferences.currentUser);

  @override
  Future<void> write({required UserDTO? user}) async {
    try {
      final encoded = user == null ? null : json.encode(user.toMap());
      await _currentUserEntry.setIfNullRemove(encoded);
    } on Object catch (e, st) {
      _throwCacheException('write', e, st);
    }
  }

  @override
  UserDTO? get() {
    final String? source;
    try {
      source = _currentUserEntry.read();
    } on Object catch (e, st) {
      _throwCacheException('read', e, st);
    }
    if (source == null) return null;
    try {
      return UserDTO.fromMap(json.decode(source) as Map<String, dynamic>);
    } on Object catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Cached user is corrupt, resetting',
      );
      _currentUserEntry.remove().ignore();
      return null;
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _currentUserEntry.remove();
    } on Object catch (e, st) {
      _throwCacheException('clear', e, st);
    }
  }

  Never _throwCacheException(String operation, Object e, StackTrace st) =>
      Error.throwWithStackTrace(
        CacheException(message: 'Local user $operation failed', cause: e),
        st,
      );
}
