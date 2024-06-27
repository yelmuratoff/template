import 'dart:convert';

import 'package:base_starter/src/common/configs/preferences/preferences_dao.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/features/auth/resource/domain/data_source/user/local_data_source.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:ispect/ispect.dart';

final class UserLocalDataSource extends PreferencesDao
    implements ILocalUserDataSource {
  const UserLocalDataSource({
    required super.sharedPreferences,
  });

  PreferencesEntry<String> get _currentUserEntry =>
      stringEntry(Preferences.currentUser);

  @override
  Future<void> write({
    required UserDTO? user,
  }) async {
    try {
      await _currentUserEntry.set(json.encode(user?.toJson()));
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Write local user failed.',
      );
      rethrow;
    }
  }

  @override
  UserDTO? get() {
    try {
      final String? token = _currentUserEntry.read();
      final Map<String, dynamic>? jsonObject =
          token != null ? json.decode(token) as Map<String, dynamic>? : null;
      return jsonObject != null ? UserDTO.fromJson(jsonObject) : null;
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Get local user failed.',
      );
      rethrow;
    }
  }

  @override
  Future<void> clear() {
    try {
      return _currentUserEntry.remove();
    } catch (e, st) {
      ISpectTalker.handle(
        exception: e,
        stackTrace: st,
        message: 'Clear local user failed.',
      );
      rethrow;
    }
  }
}
