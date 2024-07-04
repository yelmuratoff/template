part of '../settings.dart';

class _LanguagesSelector extends StatelessWidget {
  const _LanguagesSelector({
    required this.languages,
    required this.onLocaleTapped,
  });

  final List<Locale> languages;
  final void Function(Locale locale) onLocaleTapped;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: languages.length,
          itemBuilder: (_, index) {
            final language = languages.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8),
              child: _LanguageCard(
                language: language,
                onLocaleTapped: onLocaleTapped,
              ),
            );
          },
        ),
      );
}
