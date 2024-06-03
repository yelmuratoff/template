import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/change_environment.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/services/page_lifecycle_model.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/features/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/presentation/view/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ispect/ispect.dart';

part 'controller/settings_scope.dart';
part 'view/settings_view.dart';
part 'widget/app_version.dart';
part 'widget/language_card.dart';
part 'widget/language_selector.dart';
part 'widget/theme_card.dart';
part 'widget/theme_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({required this.title, super.key});

  static const String name = "Settings";
  static const String routePath = "settings";

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsPageModel _model;

  @override
  void initState() {
    _model = createModel(context, () => SettingsPageModel());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _model.dispose();
  }

  @override
  Widget build(BuildContext context) => _SettingsView(
        onTapAppVersion: () {
          _model.tapNumber++;

          if (_model.tapNumber > 5 && _model.tapNumber < 10) {
            Toaster.showToast(
              context,
              title: L10n.current.environmentTapNumber(10 - _model.tapNumber),
            );
          } else if (_model.tapNumber == 10) {
            talkerWrapper.info("ℹ️ Environment change dialog opened");
            ChangeEnvironmentDialog.show(context).then((value) {
              talkerWrapper.info("🔙 Environment change dialog closed");
            });
            _model.tapNumber = 0;
          }
        },
        onThemeChanged: ({required value}) {
          SettingsScope.themeOf(context).setThemeMode(
            value ? ThemeMode.dark : ThemeMode.light,
          );
        },
        onLocaleChanged: (locale) {
          SettingsScope.localeOf(context).setLocale(locale);
        },
        onLogoutPressed: () {
          context.dependencies.authBloc.add(const LogoutAuthEvent());
        },
      );
}
