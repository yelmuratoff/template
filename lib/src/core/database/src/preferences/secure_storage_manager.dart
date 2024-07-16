import 'dart:convert';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/core/rest_client/token_pair.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// `SecureStorageManager` - A class to manage secure storage
/// for preserving user data.
final class SecureStorageManager {
  /// Here, we create a static const `FlutterSecureStorage` object,
  /// with `encryptedSharedPreferences` enabled for Android.

  static const FlutterSecureStorage storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Methods for settings and getting `kToken`
  static Future<TokenPair?> getToken() async {
    try {
      final token = await storage.read(key: Preferences.tokenPair);
      final jsonObject =
          token != null ? json.decode(token) as Map<String, dynamic>? : null;
      return jsonObject != null ? TokenPair.fromJson(jsonObject) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setToken({
    required TokenPair? value,
  }) async {
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
