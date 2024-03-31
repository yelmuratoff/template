import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final class AppDialogs {
  const AppDialogs();

  static Future<void> dismiss() async {
    await EasyLoading.dismiss();
  }

  static void showError(BuildContext context, {String? title}) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 16
      ..textStyle = context.theme.textTheme.bodyLarge
      ..progressColor = context.theme.primaryColor
      ..backgroundColor = context.theme.colorScheme.background
      ..indicatorColor = context.theme.primaryColor
      ..textColor = context.colors.text
      ..maskColor = context.theme.colorScheme.background
      ..userInteractions = true
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..dismissOnTap = false;
    EasyLoading.dismiss();
    EasyLoading.showError(
      title ?? context.l10n.error,
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  static void showLoader(BuildContext context, {String? title}) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 16
      ..textStyle = context.theme.textTheme.bodyLarge
      ..progressColor = context.theme.primaryColor
      ..backgroundColor = context.theme.cardColor
      ..indicatorColor = context.theme.primaryColor
      ..textColor = context.colors.text
      ..maskColor = context.theme.colorScheme.background
      ..userInteractions = false
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..dismissOnTap = false;
    EasyLoading.dismiss();
    EasyLoading.show(
      status: title ?? context.l10n.loading,
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  static void showSuccess(BuildContext context, {String? title}) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 16
      ..textStyle = context.theme.textTheme.bodyLarge
      ..progressColor = context.theme.primaryColor
      ..backgroundColor = context.theme.cardColor
      ..indicatorColor = context.theme.primaryColor
      ..textColor = context.colors.text
      ..maskColor = context.theme.colorScheme.background
      ..userInteractions = true
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..dismissOnTap = false;
    EasyLoading.dismiss();
    EasyLoading.showSuccess(
      title ?? context.l10n.request_success,
      duration: const Duration(seconds: 1),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }
}
