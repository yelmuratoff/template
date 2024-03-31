part of '../settings.dart';

class _LanguagesSelector extends StatelessWidget {
  const _LanguagesSelector(this._languages);

  final List<Locale> _languages;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final language = _languages.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _LanguageCard(language),
            );
          },
        ),
      );
}
