import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
          onPressed: () => context.read<CounterCubit>().increment(),
          child: const Icon(IconsaxPlusLinear.add),
        ),
        const Gap(8),
        FloatingActionButton(
          heroTag: 'decrement',
          onPressed: () => context.read<CounterCubit>().decrement(),
          child: const Icon(IconsaxPlusLinear.minus),
        ),
      ],
    ),
    body: CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  L10n.current.counterTimesText(
                    context.watch<CounterCubit>().state,
                  ),
                  textAlign: TextAlign.center,
                  style: context.textStyles.s18w600,
                ),
                const Gap(24),
                // TEMP: yx_navigation pop repro — remove after verifying.
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const _PopReproScreen(),
                    ),
                  ),
                  child: const Text('Repro: push imperative route'),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// TEMP: yx_navigation pop repro — remove after verifying.
// Pressing back (AppBar arrow or the button) calls Navigator.of(context).pop(),
// which under yx_navigation asserts "RouteNode cannot be popped".
class _PopReproScreen extends StatelessWidget {
  const _PopReproScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Imperative route')),
    body: Center(
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Pop me'),
      ),
    ),
  );
}
