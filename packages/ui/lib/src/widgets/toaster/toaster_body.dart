part of 'toaster.dart';

class _ToasterBody extends StatelessWidget {
  const _ToasterBody({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    this.leadingImage,
  });
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final ImageProvider? leadingImage;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).extension<ITextStyles>()?.s14w500 ??
        LightThemeData.textStyles.s14w500;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingImage != null) ...[
              Image(image: leadingImage!, width: 20, height: 20),
              const Gap(8),
            ],
            Flexible(
              child: AutoSizeText(
                title,
                style: textStyle.copyWith(color: textColor),
                textScaleFactor: 1,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
