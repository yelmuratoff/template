part of 'toaster.dart';

class _ToasterBody extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool hasImage;
  const _ToasterBody({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
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
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontSize: 14,
                  ),
                  textScaleFactor: 1.0,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
}
