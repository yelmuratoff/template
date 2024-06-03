import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Localization class which is used to localize app.
/// This class provides handy methods and tools.
final class Localization {
  static Locale get computeDefaultLocale {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;

    if (AppLocalizations.delegate.isSupported(locale)) return locale;

    return const Locale('en');
  }
}
