import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/core/resource/data/database/src/secure_storage.dart';
import 'package:base_starter/src/features/auth/ui/page/auth.dart';
import 'package:ispect/ispect.dart';

final class AppUtils {
  /// `removeToken` - This function removes the token stored in secure storage, clears all providers used by the app, and navigates to the LoginScreen.
  /// If paramIsFromDrawer is true, it is passed as an extra parameter to the LoginScreen. Otherwise, the default value of false is used for this parameter.
  static Future<void> removeToken() async {
    // Log a debug message using an instance of Talker obtained from the service locator
    talkerWrapper.warning('AppUtils: "remove token" called 🥴');

    // Set the token stored in secure storage to null using await
    await SecureStorageService.setToken(null);

    /// Navigate to the LoginScreen and replace the current route with it, while passing the extra parameter indicating whether the logout is from the drawer or not.
    /// If [paramIsFromDrawer] is not null, use its value. Otherwise, use the default value of false.
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      navigatorKey.currentContext!.goNamed(AuthPage.name);
    }
  }
}
