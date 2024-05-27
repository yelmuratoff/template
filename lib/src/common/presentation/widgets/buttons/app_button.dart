import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  const AppButton({
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: () {
          onPressed.call();
        },
        color: backgroundColor ?? context.theme.colorScheme.primary,
        highlightElevation: 0,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: borderColor ?? context.theme.colorScheme.primary,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        child: Text(
          text,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: textColor ?? context.theme.colorScheme.surface,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
