import 'package:ui/ui.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/data/models/user.dart';
import 'package:base_starter/src/features/auth/presentation/auth_scope.dart';
import 'package:base_starter/src/features/auth/presentation/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => ProfileView(
    user: UserScope.userOf(context),
    onSettingsPressed: () =>
        context.dependencies.navigationManager.openSettings(),
    onLogoutPressed: () => AuthScope.of(context, listen: false).logout(),
  );
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    required this.user,
    required this.onSettingsPressed,
    required this.onLogoutPressed,
    super.key,
  });

  final UserDTO? user;
  final VoidCallback onSettingsPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.current.profile, style: context.textStyles.s20w600),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton.filledTonal(
            icon: const Icon(IconsaxPlusLinear.setting_2, color: Colors.white),
            onPressed: onSettingsPressed,
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
            user?.name ?? L10n.current.profile,
            style: context.textStyles.s18w600,
          ),
          if (user != null) ...[
            const Gap(8),
            Text(user!.email, style: context.textStyles.s16w500),
          ],
          const Gap(32),
          AppButton(onPressed: onLogoutPressed, text: L10n.current.logout),
        ],
      ),
    ),
  );
}
