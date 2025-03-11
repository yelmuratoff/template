part of '../settings_screen.dart';

/// A controller that holds and operates the app theme.
abstract interface class ThemeScopeController {
  /// Get the current [AppTheme].
  AppTheme get theme;

  /// Get is the current theme mode is [ThemeMode.dark].
  bool get isDarkMode;

  /// Set the theme mode to [themeMode].
  void setThemeMode(ThemeMode themeMode);

  /// Set the theme accent color to [color].
  void setThemeSeedColor(Color color);
}

/// A controller that holds and operates the app locale.
abstract interface class LocaleScopeController {
  /// Get the current [Locale]
  Locale get locale;

  /// Set locale to [locale].
  void setLocale(Locale locale);
}

/// A controller that holds and operates the app settings.
abstract interface class SettingsScopeController
    implements ThemeScopeController, LocaleScopeController {}

enum _SettingsScopeAspect {
  /// The theme aspect.
  theme,

  /// The locale aspect.
  locale;
}

/// Settings scope is responsible for handling settings-related stuff.
/// For example, it holds facilities to change
/// - theme seed color
/// - theme mode
/// - locale

class SettingsScope extends StatefulWidget {
  const SettingsScope({
    required this.child,
    required this.settingsBloc,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// The [SettingsBloc] instance.
  final SettingsBloc settingsBloc;

  /// Get the [SettingsScopeController] of the closest [SettingsScope] ancestor.
  static SettingsScopeController of(
    BuildContext context, {
    bool listen = true,
  }) =>
      context.inhOf<_InheritedSettingsScope>(listen: listen).controller;

  /// Get the [ThemeScopeController] of the closest [SettingsScope] ancestor.
  static ThemeScopeController themeOf(BuildContext context) => context
      .inheritFrom<_SettingsScopeAspect, _InheritedSettingsScope>(
        aspect: _SettingsScopeAspect.theme,
      )
      .controller;

  /// Get the [LocaleScopeController] of the closest [SettingsScope] ancestor.
  static LocaleScopeController localeOf(BuildContext context) => context
      .inheritFrom<_SettingsScopeAspect, _InheritedSettingsScope>(
        aspect: _SettingsScopeAspect.locale,
      )
      .controller;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope
class _SettingsScopeState extends State<SettingsScope>
    implements SettingsScopeController {
  @override
  void setLocale(Locale locale) {
    widget.settingsBloc.add(UpdateLocaleSettingsEvent(locale: locale));
  }

  @override
  void setThemeMode(ThemeMode themeMode) => widget.settingsBloc.add(
        UpdateThemeSettingsEvent(
          appTheme: AppTheme(mode: themeMode, seed: theme.seed),
        ),
      );

  @override
  void setThemeSeedColor(Color color) => widget.settingsBloc.add(
        UpdateThemeSettingsEvent(
          appTheme: AppTheme(mode: theme.mode, seed: color),
        ),
      );

  @override
  Locale get locale =>
      widget.settingsBloc.state.locale ?? L10n.computeDefaultLocale;

  @override
  AppTheme get theme =>
      widget.settingsBloc.state.appTheme ?? AppTheme.defaultTheme;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SettingsBloc, SettingsState>(
        bloc: widget.settingsBloc,
        builder: (_, state) => _InheritedSettingsScope(
          controller: this,
          state: state,
          child: widget.child,
        ),
      );

  @override
  bool get isDarkMode => theme.mode == ThemeMode.dark;
}

class _InheritedSettingsScope extends InheritedModel<_SettingsScopeAspect> {
  const _InheritedSettingsScope({
    required this.controller,
    required this.state,
    required super.child,
  });

  final SettingsScopeController controller;
  final SettingsState state;

  @override
  bool updateShouldNotify(_InheritedSettingsScope oldWidget) =>
      state != oldWidget.state;

  @override
  bool updateShouldNotifyDependent(
    covariant _InheritedSettingsScope oldWidget,
    Set<_SettingsScopeAspect> dependencies,
  ) {
    var shouldNotify = false;

    if (dependencies.contains(_SettingsScopeAspect.theme)) {
      shouldNotify = shouldNotify || state.appTheme != oldWidget.state.appTheme;
    }

    if (dependencies.contains(_SettingsScopeAspect.locale)) {
      final locale = state.locale?.languageCode;
      final oldLocale = oldWidget.state.locale?.languageCode;

      shouldNotify = shouldNotify || locale != oldLocale;
    }

    return shouldNotify;
  }
}
