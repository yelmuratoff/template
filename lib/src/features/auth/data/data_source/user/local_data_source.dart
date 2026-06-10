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
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Write local user failed.',
      );
      Error.throwWithStackTrace(
        CacheException(message: 'Failed to write local user.', cause: e),
        st,
      );
    }
  }

  @override
  UserDTO? get() {
    try {
      final source = _currentUserEntry.read();
      if (source == null) return null;
      final jsonObject = json.decode(source) as Map<String, dynamic>;
      return UserDTO.fromMap(jsonObject);
    } on Object catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Get local user failed.',
      );
      Error.throwWithStackTrace(
        CacheException(message: 'Failed to read local user.', cause: e),
        st,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _currentUserEntry.remove();
    } on Object catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Clear local user failed.',
      );
      Error.throwWithStackTrace(
        CacheException(message: 'Failed to clear local user.', cause: e),
        st,
      );
    }
  }
}
