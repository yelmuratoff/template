import 'package:flutter/material.dart';

/// Repository that manages locale information
abstract interface class ILocaleRepository {
  /// Get locale
  Future<Locale?> getLocale();

  /// Set locale
  Future<void> setLocale(Locale locale);
}
