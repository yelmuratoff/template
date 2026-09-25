import 'dart:ui';

import 'package:core/core.dart';
import 'package:database/database.dart';
import 'package:ispect/ispect.dart';

/// [ILocaleDataSource] is an entry point to the locale data layer.
/// This is used to set and get locale.

abstract interface class ILocaleDataSource {
  /// Set locale
  Future<void> setLocale(Locale locale);

  /// Get current locale from cache
  Future<Locale?> getLocale();
}

final class LocaleDataSourceLocal extends PreferencesDao
    implements ILocaleDataSource {
  const LocaleDataSourceLocal({required super.sharedPreferences});

  PreferencesEntry<String> get _locale => stringEntry('settings.locale');

  @override
  Future<void> setLocale(Locale locale) async {
    await _locale.set(locale.languageCode);
  }

  /// Returns the persisted locale, or `null` when none is stored.
  ///
  /// A corrupt entry is reset and reported as `null`, so it cannot fail
  /// startup.
  @override
  Future<Locale?> getLocale() async {
    final String? languageCode;
    try {
      languageCode = _locale.read();
    } on CacheException catch (e, st) {
      ISpect.logger.handle(
        exception: e,
        stackTrace: st,
        message: 'Stored locale is corrupt, resetting',
      );
      await _locale.remove();
      return null;
    }

    if (languageCode == null) return null;

    return Locale.fromSubtags(languageCode: languageCode);
  }
}
