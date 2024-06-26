import 'dart:convert';

import 'package:base_starter/src/common/configs/preferences/preferences_dao.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/features/auth/resource/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `UserManager` - A class to manage the current user configurations.
final class UserManager extends PreferencesDao {
  static UserManager? _instance;

  UserManager._(SharedPreferences sharedPreferences)
      : super(sharedPreferences: sharedPreferences);

  factory UserManager.initialize(SharedPreferences sharedPreferences) {
    _instance ??= UserManager._(sharedPreferences);
    return _instance!;
  }

  static UserManager get instance {
    if (_instance == null) {
      throw Exception(
        'UserManager not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  PreferencesEntry<String> get _currentUserEntry =>
      stringEntry(Preferences.currentUser);

  UserDTO? get read {
    final String? token = _currentUserEntry.read();
    final Map<String, dynamic>? jsonObject =
        token != null ? json.decode(token) as Map<String, dynamic>? : null;
    return jsonObject != null ? UserDTO.fromJson(jsonObject) : null;
  }

  Future<void> write({
    required UserDTO? user,
  }) async {
    await _currentUserEntry.set(json.encode(user?.toJson()));
  }
}
