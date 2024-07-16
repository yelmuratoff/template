import 'package:base_starter/src/app/model/app_theme.dart';

/// Theme repository that persists and retrieves theme information
abstract interface class IThemeRepository {
  /// Get theme
  Future<AppTheme?> getTheme();

  /// Set theme
  Future<void> setTheme(AppTheme theme);
}
