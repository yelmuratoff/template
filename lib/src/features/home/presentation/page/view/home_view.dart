part of '../home.dart';

class _HomePageView extends ConsumerWidget {
  final void Function() onSettingsPressed;

  const _HomePageView({
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            L10n.current.appTitle.capitalize(),
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
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
            SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      L10n.current.counterTimesText(
                        ref.watch(counterProvider),
                      ),
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
