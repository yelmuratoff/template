import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/app/router/widgets/route_wrapper.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ispect/ispect.dart';
import 'package:octopus/octopus.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) => BucketNavigator(
        bucket: RootTabsEnum.home.bucket,
        transitionDelegate: const DefaultTransitionDelegate<void>(),
        observers: [
          ISpectNavigatorObserver(),
        ],
      );
}

class HomeScreen extends StatelessWidget implements RouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CounterCubit(),
          ),
        ],
        child: this,
      );

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
                child: Text(
                  L10n.current.counterTimesText(
                    context.watch<CounterCubit>().state,
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
