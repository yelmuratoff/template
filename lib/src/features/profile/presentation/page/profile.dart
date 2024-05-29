import 'package:base_starter/src/app/router/extras.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';

part 'view/profile_model.dart';
part 'view/profile_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String name = "Profile";
  static const String routePath = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => _ProfileScreenView(
        onSettingsPressed: () {
          context.pushNamed(
            SettingsPage.name,
            queryParameters: {
              ExtraKeys.title: context.l10n.settings,
            },
          );
        },
      );
}
