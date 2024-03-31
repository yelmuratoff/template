import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/services/page_model.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/change_environment.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/feature/settings/ui/view/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

part 'controller/settings_scope.dart';
part 'view/settings_view.dart';
part 'widget/language_card.dart';
part 'widget/language_selector.dart';
part 'widget/theme_card.dart';
part 'widget/theme_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String name = "Settings";
  static const String routePath = "settings";

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
  Widget build(BuildContext context) => SettingsView(
        onTapAppVersion: () {
          _model.tapNumber++;

          if (_model.tapNumber > 5 && _model.tapNumber < 10) {
            Toaster.showToast(
              context,
              title: context.l10n.environment_tap_number(10 - _model.tapNumber),
            );
          } else if (_model.tapNumber == 10) {
            talker.debug("Environment change dialog opened");
            ChangeEnvironmentDialog.show(context).then((value) {
              talker.debug("Environment change dialog closed");
            });
            _model.tapNumber = 0;
          }
        },
      );
}
