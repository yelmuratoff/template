import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/presentation/widgets/buttons/app_button.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/change_environment.dart';
import 'package:base_starter/src/common/presentation/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/services/page_lifecycle_model.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/bloc/auth/auth_bloc.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/presentation/controller/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:ispect/ispect.dart';

part 'controller/settings_scope.dart';
part 'widget/app_version.dart';
part 'widget/language_card.dart';
part 'widget/language_selector.dart';
part 'widget/theme_card.dart';
part 'widget/theme_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({required this.title, super.key});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = PageLifecycleModel.createModel(context, SettingsPageModel.new);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final versionTextColor =
        context.theme.colorScheme.onSurface.withOpacity(0.5);
    final titleMediumTextStyle = context.textStyles.s18w600.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            IconsaxPlusLinear.arrow_square_left,
          ),
        ),
        title: Text(
          L10n.current.settings,
          style: context.textStyles.s24w700,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  L10n.current.locales,
                  style: titleMediumTextStyle,
                ),
              ),
              _LanguagesSelector(
                languages: L10n.supportedLocales,
                onLocaleTapped: (locale) {
                  SettingsScope.localeOf(context).setLocale(locale);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  L10n.current.defaultThemes,
                  style: titleMediumTextStyle,
                ),
              ),
              const _ThemeSelector(Colors.primaries),
              SwitchListTile(
                title: Text(
                  L10n.current.changeTheme,
                  style: titleMediumTextStyle,
                ),
                value: SettingsScope.themeOf(context).isDarkMode,
                onChanged: (value) {
                  SettingsScope.themeOf(context).setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Align(
              child: SizedBox.square(
                dimension: 100,
                child: Theme(
                  data: context.theme.copyWith(
                    cardTheme: CardTheme(
                      color: context.theme.colorScheme.primaryContainer,
                      elevation: 0,
                    ),
                    colorScheme: context.theme.colorScheme.copyWith(
                      primary: context.theme.colorScheme.primary,
                      secondary: context.theme.colorScheme.secondary,
                      surface: context.theme.colorScheme.surface,
                    ),
                  ),
                  child: const Card(margin: EdgeInsets.all(8)),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _AppVersionBody(
                  onTapAppVersion: () async {
                    _model.tapNumber++;

                    if (_model.tapNumber > 5 && _model.tapNumber < 10) {
                      await Toaster.showToast(
                        title: L10n.current
                            .environmentTapNumber(10 - _model.tapNumber),
                      );
                    } else if (_model.tapNumber == 10) {
                      ISpect.info('ℹ️ Environment change dialog opened');
                      await ChangeEnvironmentDialog.show(context);
                      ISpect.info(
                        '🔙 Environment change dialog closed',
                      );
                      _model.tapNumber = 0;
                    }
                  },
                  versionTextColor: versionTextColor,
                ),
                const Gap(24),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) => switch (state) {
                    LoadingAuthState() => AppDialogs.showLoader(
                        context,
                        title: L10n.current.loading,
                      ),
                    _ => AppDialogs.dismiss(),
                  },
                  child: AppButton(
                    onPressed: () {
                      context.dependencies.authBloc
                          .add(const LogoutAuthEvent());
                    },
                    text: L10n.current.logout,
                  ),
                ),
                const Gap(32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
