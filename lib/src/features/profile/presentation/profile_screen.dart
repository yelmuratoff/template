import 'package:base_starter/src/app/router/enums/root_tabs_enum.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ispect/ispect.dart';
import 'package:octopus/octopus.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) => BucketNavigator(
        bucket: RootTabsEnum.profile.bucket,
        transitionDelegate: const DefaultTransitionDelegate<void>(),
        observers: [
          ISpectNavigatorObserver(),
        ],
      );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.current.profile,
            style: context.textStyles.s20w600,
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filledTonal(
                icon: const Icon(
                  IconsaxPlusLinear.setting_2,
                  color: Colors.white,
                ),
                onPressed: () => context.octopus.setState(
                  (state) => state
                    ..findByName(RootTabsEnum.profile.bucket)?.add(
                      Routes.settings.node(),
                    ),
                ),
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
                style: context.textStyles.s18w600,
              ),
            ],
          ),
        ),
      );
}
