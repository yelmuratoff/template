import 'package:base_starter/src/app/router/extras.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String name = "Profile";
  static const String routePath = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  Icons.settings_rounded,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                  SettingsPage.name,
                  queryParameters: {
                    ExtraKeys.title: L10n.current.settings,
                  },
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
