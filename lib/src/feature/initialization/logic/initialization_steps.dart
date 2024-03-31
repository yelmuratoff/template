import 'dart:async';

import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/services/app_config.dart';
import 'package:base_starter/src/feature/initialization/model/environment.dart';
import 'package:base_starter/src/feature/initialization/model/initialization_progress.dart';
import 'package:base_starter/src/feature/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/feature/settings/data/locale/locale_datasource.dart';
import 'package:base_starter/src/feature/settings/data/locale/locale_repository.dart';
import 'package:base_starter/src/feature/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/feature/settings/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/feature/settings/data/theme/theme_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The `Dependencies` object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Package Info': (progress) async {
      final packageInfo = await PackageInfo.fromPlatform();
      progress.dependencies.packageInfo = packageInfo;
    },
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'App Configs': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      AppConfigsService.initialize(sharedPreferences);
    },
    'Environment': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final String? environment =
          sharedPreferences.getString(Preferences.environment);
      if (environment == null) {
        await sharedPreferences.setString(
          Preferences.environment,
          Environment.prod.value,
        );
      }
    },
    'Settings Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final localeRepository = LocaleRepositoryImpl(
        localeDataSource:
            LocaleDataSourceLocal(sharedPreferences: sharedPreferences),
      );

      final themeRepository = ThemeRepositoryImpl(
        themeDataSource: ThemeDataSourceLocal(
          sharedPreferences: sharedPreferences,
          codec: const ThemeModeCodec(),
        ),
      );

      final localeFuture = localeRepository.getLocale();
      final theme = await themeRepository.getTheme();
      final locale = await localeFuture;

      final initialState = SettingsState.idle(appTheme: theme, locale: locale);

      final settingsBloc = SettingsBloc(
        localeRepository: localeRepository,
        themeRepository: themeRepository,
        initialState: initialState,
      );

      progress.dependencies.settingsBloc = settingsBloc;
    },
  };
}
