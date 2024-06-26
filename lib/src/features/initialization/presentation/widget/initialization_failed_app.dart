import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/talker.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/core/di/containers/dependencies.dart';
import 'package:base_starter/src/core/di/containers/repositories.dart';
import 'package:base_starter/src/core/di/dependencies_scope.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:base_starter/src/features/settings/resource/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/resource/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/resource/data/theme/theme_repository.dart';
import 'package:base_starter/src/features/settings/resource/domain/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/resource/domain/theme/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ispect/ispect.dart';
import 'package:ispect/ispect_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

/// InitializationFailedScreen widget
class InitializationFailedApp extends StatefulWidget {
  /// The error that caused the initialization to fail.
  final Object error;

  /// The stack trace of the error that caused the initialization to fail.
  final StackTrace stackTrace;

  /// The callback that will be called when the retry button is pressed.
  ///
  /// If null, the retry button will not be shown.
  final Future<void> Function()? retryInitialization;

  const InitializationFailedApp({
    required this.error,
    required this.stackTrace,
    this.retryInitialization,
    super.key,
  });

  @override
  State<InitializationFailedApp> createState() =>
      _InitializationFailedAppState();
}

class _InitializationFailedAppState extends State<InitializationFailedApp> {
  /// Whether the initialization is in progress.
  final _inProgress = ValueNotifier<bool>(false);
  late final SharedPreferences sharedPreferences;

  SettingsState? settingsState;
  ILocaleRepository? localeRepository;
  IThemeRepository? themeRepository;

  bool _isInitialized = false;

  /// ISpect fields
  final Talker talker = TalkerFlutter.init();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
    localeRepository = LocaleRepository(
      localeDataSource: LocaleDataSourceLocal(
        sharedPreferences: sharedPreferences,
      ),
    );
    themeRepository = ThemeRepository(
      themeDataSource: ThemeDataSourceLocal(
        sharedPreferences: sharedPreferences,
        codec: const ThemeModeCodec(),
      ),
    );
    final localeFuture = localeRepository?.getLocale();
    final theme = await themeRepository?.getTheme();
    final locale = await localeFuture;

    settingsState = IdleSettingsState(appTheme: theme, locale: locale);
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _inProgress.dispose();
    super.dispose();
  }

  Future<void> _retryInitialization() async {
    _inProgress.value = true;
    await widget.retryInitialization!();
    _inProgress.value = false;
  }

  @override
  Widget build(BuildContext context) => _isInitialized
      ? DependenciesScope(
          dependencies: Dependencies(),
          repositories: Repositories(),
          child: SettingsScope(
            settingsBloc: SettingsBloc(
              localeRepository: localeRepository!,
              themeRepository: themeRepository!,
              initialState: settingsState!,
            ),
            child: MaterialApp(
              theme: settingsState?.appTheme?.lightTheme,
              darkTheme: settingsState?.appTheme?.darkTheme,
              themeMode: settingsState?.appTheme?.mode,
              locale: settingsState?.locale,
              localizationsDelegates: Localization.delegates,
              supportedLocales: L10n.delegate.supportedLocales,
              home: _View(
                error: widget.error,
                retryInitialization: widget.retryInitialization != null
                    ? _retryInitialization
                    : null,
                stackTrace: widget.stackTrace,
                talker: talker,
                themeMode: settingsState?.appTheme?.mode ?? ThemeMode.system,
                lightTheme:
                    settingsState?.appTheme?.lightTheme ?? ThemeData.light(),
                darkTheme:
                    settingsState?.appTheme?.darkTheme ?? ThemeData.dark(),
                locale: settingsState?.locale ?? const Locale('en'),
              ),
            ),
          ),
        )
      : MaterialApp(
          home: Scaffold(
            body: Center(
              child: Image.asset(
                Assets.images.splash.path,
              ),
            ),
          ),
        );
}

class _View extends StatelessWidget {
  final Object error;
  final Future<void> Function()? retryInitialization;
  final StackTrace stackTrace;
  final Talker talker;
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final Locale locale;

  const _View({
    required this.error,
    required this.stackTrace,
    required this.talker,
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required this.locale,
    this.retryInitialization,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.current.initializationFailed,
            style: context.textStyles.s20w600.copyWith(
              color: context.theme.colorScheme.error,
            ),
          ),
          actions: [
            if (F.isDev) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton.filledTonal(
                  icon: const Icon(Icons.monitor_heart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ISpectPage(
                          options: ISpectOptions(
                            locale: locale,
                          ),
                        ),
                      ),
                    );
                  },
                  splashRadius: 8,
                  color: context.theme.colorScheme.error,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        context.theme.colorScheme.error.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${L10n.current.errorType}: ${error.toString()}',
                style: context.textStyles.s16w500.copyWith(
                  color: context.theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (retryInitialization != null)
                    ElevatedButton(
                      onPressed: retryInitialization,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.colorScheme.error,
                      ),
                      child: Row(
                        children: [
                          Text(
                            L10n.current.retry,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Gap(8),
                          const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.theme.colorScheme.error,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'StackTrace: \n$stackTrace',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 50,
                      style: context.textStyles.s14w400.copyWith(
                        color: context.theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
