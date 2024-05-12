import 'dart:convert';

import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/core/resource/domain/token/token_pair.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// This class is called `SecureStorageService` for preserving user data in the secure storage.
final class SecureStorageService {
  /// Here, we create a static const `FlutterSecureStorage` object, with `encryptedSharedPreferences` enabled for Android.

  static const FlutterSecureStorage storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Methods for settings and getting `kToken`
  static Future<TokenPair?> getToken() async {
    try {
      final String? token = await storage.read(key: Preferences.tokenPair);
      final Map<String, dynamic>? jsonObject =
          token != null ? json.decode(token) as Map<String, dynamic>? : null;
      return jsonObject != null ? TokenPair.fromJson(jsonObject) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setToken(TokenPair? value) async {
    try {
      await storage.write(
        key: Preferences.tokenPair,
        value: json.encode(value?.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }
}
