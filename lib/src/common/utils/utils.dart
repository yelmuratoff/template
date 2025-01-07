import 'dart:convert';

import 'package:base_starter/src/core/database/src/preferences/secure_storage_manager.dart';

final class AppUtils {
  /// `removeToken` - This function removes the token stored in secure storage,
  /// clears all providers used by the app, and navigates to the LoginScreen.
  /// If paramIsFromDrawer is true, it is passed as an extra parameter to the
  /// LoginScreen. Otherwise, the default value of false is used for this
  /// parameter.
  static Future<void> exit() async {
    // Set the token stored in secure storage to null using await
    await SecureStorageManager.setToken(value: null);

    /// Navigate to the LoginScreen and replace the current route with it,
    /// while passing the extra parameter indicating whether the logout is
    /// from the drawer or not.
    /// If [paramIsFromDrawer] is not null, use its value. Otherwise, use the
    /// default value of false.
    // final context = navigatorKey.currentContext;
    // if (context != null && context.mounted) {
    //   context.dependencies.userCubit.clear();
    //   const AuthRoute().go(context);
    // }
  }

  /// `formatPrettyJson` - This function formats a map of strings as a pretty
  /// JSON string.
  static String formatPrettyJson(Map<String, String> data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }
}
