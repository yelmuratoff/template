import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/configs/preferences/preferences.dart';
import 'package:base_starter/src/common/presentation/pages/restart_wrapper.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/features/initialization/model/environment.dart';
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
          context.l10n.changeEnvironment,
          style: context.theme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Environment.values
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
                          style: context.theme.textTheme.titleMedium,
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
                            env.value == Environment.dev.value;
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
                          title: context.l10n.error,
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