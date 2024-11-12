import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/common/presentation/pages/restart_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ispect/ispect.dart';

final class ChangeEnvironmentDialog {
  const ChangeEnvironmentDialog();

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          L10n.current.changeEnvironment,
          style: context.textStyles.s18w600,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Flavor.values
              .map(
                (env) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: context.theme.colorScheme.primary,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    title: Row(
                      children: [
                        if (F.appFlavor == env) ...[
                          Icon(
                            IconsaxPlusLinear.tick_square,
                            color: context.theme.colorScheme.primary,
                          ),
                          const Gap(8),
                        ],
                        Text(
                          env.name,
                          style: context.textStyles.s18w600,
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    dense: true,
                    onTap: () {
                      try {
                        F.appFlavor = env;
                        context.dependencies.sharedPreferences.setString(
                          Preferences.environment,
                          env.name,
                        );
                        ISpect.warning(
                          'Environment changed to ${env.name}',
                        );
                        ISpect.read(context).setISpect =
                            env.name == Flavor.dev.name;
                        Navigator.pop(context);
                        RestartWrapper.restartApp(navigatorKey.currentContext!);
                      } catch (e, st) {
                        ISpect.handle(
                          exception: e,
                          stackTrace: st,
                          message: 'Error changing environment',
                        );
                        Toaster.showErrorToast(
                          context,
                          title: L10n.current.error,
                        );
                      }
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
