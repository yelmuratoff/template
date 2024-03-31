part of '../settings.dart';

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector(this._colors);

  final List<Color> _colors;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            final color = _colors.elementAt(index);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _ThemeCard(color),
            );
          },
        ),
      );
}
