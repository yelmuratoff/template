part of '../settings.dart';

class SettingsView extends StatelessWidget {
  final void Function() onTapAppVersion;
  const SettingsView({required this.onTapAppVersion, super.key});

  @override
  Widget build(BuildContext context) {
    final _versionTextColor =
        context.theme.colorScheme.onSurface.withOpacity(0.5);
    final _titleMediumTextStyle = context.theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          context.l10n.settings,
          style: context.theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.l10n.locales,
                  style: _titleMediumTextStyle,
                ),
              ),
              _LanguagesSelector(Localization.supportedLocales),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.l10n.defaultThemes,
                  style: _titleMediumTextStyle,
                ),
              ),
              const _ThemeSelector(Colors.primaries),
              SwitchListTile(
                title: Text(
                  context.l10n.changeTheme,
                  style: _titleMediumTextStyle,
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
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
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
                    child: const Card(
                      margin: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _AppVersionBody(
                  onTapAppVersion: onTapAppVersion,
                  versionTextColor: _versionTextColor,
                ),
                const Gap(24),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) => switch (state) {
                    LoadingAuthState() => AppDialogs.showLoader(
                        context,
                        title: context.l10n.loading,
                      ),
                    _ => AppDialogs.dismiss(),
                  },
                  child: AppButton(
                    onPressed: () {
                      context.dependencies.authBloc
                          .add(const LogoutAuthEvent());
                    },
                    text: context.l10n.logout,
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
