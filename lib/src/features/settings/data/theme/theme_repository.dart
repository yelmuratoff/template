import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';

/// Theme repository that persists and retrieves theme information
abstract interface class IThemeRepository {
  /// Get theme
  Future<AppTheme?> getTheme();

  /// Set theme
  Future<void> setTheme(AppTheme theme);
}

/// Theme repository implementation
final class ThemeRepositoryImpl implements IThemeRepository {
  /// Create theme repository
  const ThemeRepositoryImpl({required IThemeDataSource themeDataSource})
      : _themeDataSource = themeDataSource;

  final IThemeDataSource _themeDataSource;

  @override
  Future<AppTheme?> getTheme() => _themeDataSource.getTheme();

  @override
  Future<void> setTheme(AppTheme theme) => _themeDataSource.setTheme(theme);
}
