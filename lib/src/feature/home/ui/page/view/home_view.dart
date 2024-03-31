part of '../home.dart';

class HomeView extends ConsumerWidget {
  final void Function() onSettingsPressed;
  final void Function() onLoggerPressed;
  const HomeView({
    required this.onSettingsPressed,
    required this.onLoggerPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: const Icon(Icons.add),
            ),
            const Gap(8),
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => ref.read(counterProvider.notifier).decrement(),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.app_title.capitalize(),
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.settings_rounded),
                        onPressed: () => onSettingsPressed(),
                        splashRadius: 8,
                      ),
                      if (context.config.isDev) ...[
                        IconButton.filledTonal(
                          icon: const Icon(Icons.monitor_heart),
                          onPressed: () => onLoggerPressed(),
                          splashRadius: 8,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      context.l10n.counter_times_text(
                        ref.watch(counterProvider),
                      ),
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: context.theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
