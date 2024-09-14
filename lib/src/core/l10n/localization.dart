import 'package:base_starter/src/core/l10n/generated/app_localizations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Localization class which is used to localize app.
/// This class provides handy methods and tools.
/// Usage:
/// Before using L10n.localizations, ensure to call L10n.load(locale).
/// Example:
/// L10n.load(Locale('en'));
/// var myString = L10n.localizations.someTranslation;
final class L10n {
  static late AppLocalizations _localizations;

  /// Initialize the L10n class with the correct localization
  static void load(Locale locale) {
    _localizations = lookupAppLocalizations(locale);
  }

  /// Access localized strings directly
  static AppLocalizations get current => _localizations;

  static LocalizationsDelegate<Object> get delegate =>
      AppLocalizations.delegate;

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  static Locale get computeDefaultLocale {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    if (AppLocalizations.delegate.isSupported(locale)) return locale;

    return const Locale('en');
  }

  static List<LocalizationsDelegate<dynamic>> get delegates => [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];
}
