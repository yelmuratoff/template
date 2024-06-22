import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/constants/preferences.dart';
import 'package:base_starter/src/common/presentation/pages/restart_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/features/initialization/model/env_type.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
          children: EnvType.values
              .map(
                (env) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: context.theme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Row(
                      children: [
                        if (context.config.environment == env) ...[
                          Icon(
                            Icons.check_circle_outline_rounded,
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
                        context.dependencies.sharedPreferences.setString(
                          Preferences.environment,
                          env.value,
                        );
                        talkerWrapper.warning(
                          "Environment changed to ${env.name}",
                        );
                        ISpect.read(context).setISpect =
                            env.value == EnvType.dev.value;
                        Navigator.pop(context);
                        RestartWrapper.restartApp(navigatorKey.currentContext!);
                      } catch (e, st) {
                        talkerWrapper.handle(
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
