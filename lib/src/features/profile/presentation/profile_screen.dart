import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            onPressed: () =>
                context.dependencies.navigationManager.openSettings(),
            splashRadius: 8,
          ),
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(L10n.current.profile, style: context.textStyles.s18w600),
        ],
      ),
    ),
  );
}
