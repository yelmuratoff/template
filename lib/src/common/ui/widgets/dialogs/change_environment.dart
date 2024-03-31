import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/ui/pages/restart_wrapper.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/initialization/model/environment.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final class ChangeEnvironmentDialog {
  const ChangeEnvironmentDialog();

  static Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.change_environment,
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
                        talker.warning("Environment changed to ${env.name}");
                        Navigator.pop(context);
                        RestartWrapper.restartApp(navigatorKey.currentContext!);
                      } catch (e, st) {
                        talker.handle(e, st);
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
