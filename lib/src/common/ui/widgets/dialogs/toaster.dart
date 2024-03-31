import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

part 'toaster_body.dart';

final class Toaster {
  const Toaster._();

  static Future<void> showToast(
    BuildContext context, {
    required String title,
    Color backgroundColor = const Color(0xff3d3b3b),
    Color textColor = Colors.white,
    bool hasImage = true,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(seconds: 1),
    ToastGravity gravity = ToastGravity.BOTTOM,
    void Function()? then,
  }) async {
    fToast.removeCustomToast();
    fToast.showToast(
      child: _ToasterBody(
        title: title,
        backgroundColor: backgroundColor,
        textColor: textColor,
        hasImage: hasImage,
      ),
      gravity: gravity,
      fadeDuration: fadeDuration,
      toastDuration: toastDuration,
      ignorePointer: isIgnorePointer,
      isDismissable: isDismissable,
    );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }

  static Future<void> showSuccessToast(
    BuildContext context, {
    required String title,
    void Function()? then,
    Color textColor = Colors.white,
    bool hasImage = false,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(milliseconds: 1500),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) async {
    fToast.removeCustomToast();
    fToast.showToast(
      child: _ToasterBody(
        title: title,
        backgroundColor: context.colors.success,
        textColor: textColor,
        hasImage: hasImage,
      ),
      gravity: gravity,
      fadeDuration: fadeDuration,
      toastDuration: toastDuration,
      ignorePointer: isIgnorePointer,
      isDismissable: isDismissable,
    );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }

  static Future<void> showErrorToast(
    BuildContext context, {
    required String title,
    void Function()? then,
    Color textColor = Colors.white,
    bool hasImage = false,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(milliseconds: 1500),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) async {
    fToast.removeCustomToast();
    fToast.showToast(
      child: _ToasterBody(
        title: title,
        backgroundColor: context.colors.error,
        textColor: textColor,
        hasImage: hasImage,
      ),
      gravity: gravity,
      fadeDuration: fadeDuration,
      toastDuration: toastDuration,
      ignorePointer: isIgnorePointer,
      isDismissable: isDismissable,
    );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }
}
