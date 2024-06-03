part of '../profile.dart';

class _ProfileScreenView extends StatelessWidget {
  final void Function() onSettingsPressed;
  const _ProfileScreenView({
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.current.profile,
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filledTonal(
                icon: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                ),
                onPressed: () => onSettingsPressed(),
                splashRadius: 8,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                L10n.current.profile,
                style: context.theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}
