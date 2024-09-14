import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/state/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            L10n.current.appTitle.capitalize(),
            style: context.textStyles.s24w700,
          ),
          centerTitle: false,
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'increment',
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: const Icon(IconsaxPlusLinear.add),
            ),
            const Gap(8),
            FloatingActionButton(
              heroTag: 'decrement',
              onPressed: () => ref.read(counterProvider.notifier).decrement(),
              child: const Icon(IconsaxPlusLinear.minus),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  L10n.current.counterTimesText(
                    ref.watch(counterProvider),
                  ),
                  textAlign: TextAlign.center,
                  style: context.textStyles.s18w600,
                ),
              ),
            ),
          ],
        ),
      );
}
