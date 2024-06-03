import 'dart:ui';

import 'package:base_starter/src/features/settings/data/locale/locale_datasource.dart';

/// Repository that manages locale information
abstract interface class ILocaleRepository {
  /// Get locale
  Future<Locale?> getLocale();

  /// Set locale
  Future<void> setLocale(Locale locale);
}

/// Locale repository implementation
final class LocaleRepositoryImpl implements ILocaleRepository {
  /// Create locale repository
  const LocaleRepositoryImpl({required ILocaleDataSource localeDataSource})
      : _localeDataSource = localeDataSource;

  final ILocaleDataSource _localeDataSource;

  @override
  Future<Locale?> getLocale() => _localeDataSource.getLocale();

  @override
  Future<void> setLocale(Locale locale) => _localeDataSource.setLocale(locale);
}
