import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Localization class which is used to localize app.
/// This class provides handy methods and tools.
final class Localization {
  static Locale get computeDefaultLocale {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    if (L10n.delegate.isSupported(locale)) return locale;

    return const Locale('en');
  }

  static List<LocalizationsDelegate<dynamic>> get delegates => [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];
}
