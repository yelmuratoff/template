import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyles =
        Theme.of(context).extension<ITextStyles>() ?? LightThemeData.textStyles;
    return MaterialButton(
      onPressed: onPressed,
      color: backgroundColor ?? colorScheme.primary,
      highlightElevation: 0,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: borderColor ?? colorScheme.primary),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      child: Text(
        text,
        style: textStyles.s16w600.copyWith(
          color: textColor ?? colorScheme.surface,
        ),
      ),
    );
  }
}
