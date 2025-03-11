import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/domain/theme/theme_repository.dart';

/// Theme repository implementation
final class ThemeRepository implements IThemeRepository {
  /// Create theme repository
  const ThemeRepository({required IThemeDataSource themeDataSource})
      : _themeDataSource = themeDataSource;

  final IThemeDataSource _themeDataSource;

  @override
  Future<AppTheme?> getTheme() => _themeDataSource.getTheme();

  @override
  Future<void> setTheme(AppTheme theme) => _themeDataSource.setTheme(theme);
}
