import 'package:base_starter/src/common/presentation/widgets/app_loading_indicator.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = indicatorType
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..radius = 16
      ..textStyle = context.textStyles.s16w500
      ..progressColor = context.theme.primaryColor
      ..backgroundColor = context.theme.colorScheme.surface
      ..indicatorColor = context.theme.primaryColor
      ..textColor = context.colors.text
      ..maskColor = context.theme.colorScheme.surface
      ..userInteractions = true
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..dismissOnTap = false;
  }

  static void showError(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.dualRing);

    EasyLoading.dismiss();
    EasyLoading.showError(
      title ?? L10n.current.error,
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  static void showLoader(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.circle);
    EasyLoading.dismiss();

    EasyLoading.show(
      status: title ?? L10n.current.loading,
      indicator: const AppLoadingIndicator(),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  static void showSuccess(BuildContext context, {String? title}) {
    _configEasyLoading(context, EasyLoadingIndicatorType.dualRing);
    EasyLoading.dismiss();

    EasyLoading.showSuccess(
      title ?? L10n.current.requestSuccess,
      duration: const Duration(seconds: 1),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }
}
