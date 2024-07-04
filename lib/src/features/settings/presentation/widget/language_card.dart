part of '../settings.dart';

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.onLocaleTapped,
  });

  final Locale language;
  final void Function(Locale locale) onLocaleTapped;

  @override
  Widget build(BuildContext context) => Card(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: InkWell(
            onTap: () => onLocaleTapped.call(language),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: SizedBox(
              width: 64,
              child: Center(
                child: Text(
                  language.languageCode,
                  style: context.textStyles.s14w500.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
