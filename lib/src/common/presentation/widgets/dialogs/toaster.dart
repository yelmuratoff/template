import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

part 'toaster_body.dart';

/// This line declares a global variable which is used to show toast messages.
final FToast fToast = FToast();

final class Toaster {
  const Toaster._();

  static Future<void> showToast({
    required String title,
    Color backgroundColor = const Color.fromARGB(255, 43, 42, 42),
    Color textColor = Colors.white,
    bool hasImage = true,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(seconds: 1),
    ToastGravity gravity = ToastGravity.BOTTOM,
    VoidCallback? then,
  }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
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
    VoidCallback? then,
    Color textColor = Colors.white,
    bool hasImage = false,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(milliseconds: 1500),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
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
    VoidCallback? then,
    Color textColor = Colors.white,
    bool hasImage = false,
    bool isDismissable = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(milliseconds: 1500),
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
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
