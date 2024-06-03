part of '../home.dart';

class _HomePageView extends ConsumerWidget {
  final void Function() onSettingsPressed;
  final void Function(WidgetRef) onIncrementPressed;
  final void Function(WidgetRef) onDecrementPressed;

  const _HomePageView({
    required this.onSettingsPressed,
    required this.onIncrementPressed,
    required this.onDecrementPressed,
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
              onPressed: () => onIncrementPressed.call(ref),
              child: const Icon(Icons.add),
            ),
            const Gap(8),
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => onDecrementPressed.call(ref),
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
