part of '../settings.dart';

class _SettingsView extends StatelessWidget {
  final void Function() onTapAppVersion;
  final void Function(Locale) onLocaleChanged;
  final void Function() onLogoutPressed;
  final void Function({
    required bool value,
  }) onThemeChanged;
  const _SettingsView({
    required this.onTapAppVersion,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.onLogoutPressed,
  });

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
          L10n.current.settings,
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
                  L10n.current.locales,
                  style: _titleMediumTextStyle,
                ),
              ),
              _LanguagesSelector(
                languages: AppLocalizations.supportedLocales,
                onLocaleTapped: onLocaleChanged,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  L10n.current.defaultThemes,
                  style: _titleMediumTextStyle,
                ),
              ),
              const _ThemeSelector(Colors.primaries),
              SwitchListTile(
                title: Text(
                  L10n.current.changeTheme,
                  style: _titleMediumTextStyle,
                ),
                value: SettingsScope.themeOf(context).isDarkMode,
                onChanged: (value) {
                  onThemeChanged.call(value: value);
                },
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                SizedBox.square(
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
                        title: L10n.current.loading,
                      ),
                    _ => AppDialogs.dismiss(),
                  },
                  child: AppButton(
                    onPressed: () {
                      onLogoutPressed.call();
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
