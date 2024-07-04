part of 'toaster.dart';

class _ToasterBody extends StatelessWidget {
  const _ToasterBody({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.hasImage,
  });
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool hasImage;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasImage) ...[
                Image.asset(
                  Assets.images.icon1024x1024.path,
                  width: 20,
                  height: 20,
                ),
                const Gap(8),
              ],
              Flexible(
                child: AutoSizeText(
                  title,
                  style: context.textStyles.s14w500.copyWith(
                    color: textColor,
                  ),
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
