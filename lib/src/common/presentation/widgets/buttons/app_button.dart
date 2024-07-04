import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    super.key,
  });
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onPressed,
        color: backgroundColor ?? context.theme.colorScheme.primary,
        highlightElevation: 0,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: borderColor ?? context.theme.colorScheme.primary,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        child: Text(
          text,
          style: context.textStyles.s16w600.copyWith(
            color: textColor ?? context.theme.colorScheme.surface,
          ),
        ),
      );
}
