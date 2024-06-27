import 'dart:ui';

import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/configs/preferences/secure_storage_manager.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/auth/presentation/auth.dart';
import 'package:ispect/ispect.dart';

final class AppUtils {
  /// `removeToken` - This function removes the token stored in secure storage, clears all providers used by the app, and navigates to the LoginScreen.
  /// If paramIsFromDrawer is true, it is passed as an extra parameter to the LoginScreen. Otherwise, the default value of false is used for this parameter.
  static Future<void> removeToken() async {
    // Log a debug message using an instance of Talker obtained from the service locator
    ISpectTalker.warning('AppUtils: "remove token" called 🥴');

    // Set the token stored in secure storage to null using await
    await SecureStorageManager.setToken(value: null);

    /// Navigate to the LoginScreen and replace the current route with it, while passing the extra parameter indicating whether the logout is from the drawer or not.
    /// If [paramIsFromDrawer] is not null, use its value. Otherwise, use the default value of false.
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      context.dependencies.userCubit.clear();
      context.goNamed(AuthPage.name);
    }
  }

  /// `adjustColorBrightness` - This function adjusts the brightness of a color by the specified amount.
  static Color adjustColorBrightness(Color color, double brightness) {
    assert(
      brightness >= 0.0 && brightness <= 1.0,
      'Brightness must be between 0.0 and 1.0',
    );

    final int red =
        ((color.red * brightness) + (255 * (1.0 - brightness))).round();
    final int green =
        ((color.green * brightness) + (255 * (1.0 - brightness))).round();
    final int blue =
        ((color.blue * brightness) + (255 * (1.0 - brightness))).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }

  /// `adjustColorDarken` - This function darkens a color by the specified amount.
  static Color adjustColorDarken(Color color, double darken) {
    assert(
      darken >= 0.0 && darken <= 1.0,
      'Darken must be between 0.0 and 1.0',
    );

    final int red = (color.red * (1.0 - darken)).round();
    final int green = (color.green * (1.0 - darken)).round();
    final int blue = (color.blue * (1.0 - darken)).round();

    return Color.fromARGB(color.alpha, red, green, blue);
  }
}
