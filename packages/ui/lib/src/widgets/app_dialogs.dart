import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ui/src/widgets/app_loading_indicator.dart';
import 'package:ui/ui.dart';

/// `AppDialogs` is a class that provides a set of methods
/// to show different types of dialogs.
final class AppDialogs {
  const AppDialogs();

  static Future<void> dismiss() async {
    await EasyLoading.dismiss();
  }

  static void _configEasyLoading(
    BuildContext context,
    EasyLoadingIndicatorType indicatorType,
  ) {
    final theme = Theme.of(context);
    final textStyles =
        theme.extension<ITextStyles>() ?? LightThemeData.textStyles;
    final colors = theme.extension<IColors>()!;
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = indicatorType
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 16
      ..textStyle = textStyles.s16w500
      ..progressColor = theme.primaryColor
      ..backgroundColor = theme.colorScheme.surface
      ..indicatorColor = theme.primaryColor
      ..textColor = colors.text
      ..maskColor = theme.colorScheme.surface
      ..userInteractions = true
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..dismissOnTap = false;
  }

  static void showError(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.dualRing);

    EasyLoading.dismiss();
    EasyLoading.showError(
      title ?? 'Error',
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  static void showLoader(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.circle);
    EasyLoading.dismiss();

    EasyLoading.show(
      status: title ?? 'Loading',
      indicator: const AppLoadingIndicator(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  static void showSuccess(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.dualRing);
    EasyLoading.dismiss();

    EasyLoading.showSuccess(
      title ?? 'Success',
      duration: const Duration(seconds: 1),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }
}
