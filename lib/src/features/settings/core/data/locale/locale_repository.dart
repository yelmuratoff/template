import 'dart:ui';

import 'package:base_starter/src/features/settings/core/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/core/domain/locale/locale_repository.dart';

/// Locale repository implementation
final class LocaleRepository implements ILocaleRepository {
  /// Create locale repository
  const LocaleRepository({required ILocaleDataSource localeDataSource})
      : _localeDataSource = localeDataSource;

  final ILocaleDataSource _localeDataSource;

  @override
  Future<Locale?> getLocale() => _localeDataSource.getLocale();

  @override
  Future<void> setLocale(Locale locale) => _localeDataSource.setLocale(locale);
}
