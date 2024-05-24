import 'package:base_starter/src/common/configs/constants.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/assets/generated/assets.gen.dart';
import 'package:base_starter/src/core/localization/localization.dart';
import 'package:base_starter/src/features/initialization/logic/base_config.dart';
import 'package:base_starter/src/features/initialization/model/dependencies.dart';
import 'package:base_starter/src/features/initialization/model/environment.dart';
import 'package:base_starter/src/features/initialization/ui/widget/dependencies_scope.dart';
import 'package:base_starter/src/features/initialization/ui/widget/environment_scope.dart';
import 'package:base_starter/src/features/settings/bloc/settings_bloc.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_datasource.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_datasource.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_mode_codec.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_repository.dart';
import 'package:base_starter/src/features/settings/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ispect/ispect.dart';
import 'package:ispect/ispect_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
  String? _environmentKey;

  SettingsState? settingsState;
  LocaleRepository? localeRepository;
  ThemeRepository? themeRepository;

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
    _environmentKey = sharedPreferences.getString(Preferences.environment);
    localeRepository = LocaleRepositoryImpl(
      localeDataSource: LocaleDataSourceLocal(
        sharedPreferences: sharedPreferences,
      ),
    );
    themeRepository = ThemeRepositoryImpl(
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
      ? EnvironmentScope(
          config:
              configMap[_environmentKey] ?? configMap[Environment.prod.value]!,
          child: DependenciesScope(
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
                localizationsDelegates: Localization.localizationDelegates,
                supportedLocales: Localization.supportedLocales,
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
  Widget build(BuildContext context) {
    final bool isDev = context.config.isDev;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.initializationFailed,
          style: context.theme.textTheme.titleLarge?.copyWith(
            color: context.theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (isDev) ...[
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
                          themeMode: themeMode,
                          lightTheme: lightTheme,
                          darkTheme: darkTheme,
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
              '${context.l10n.errorType}: ${error.toString()}',
              style: context.theme.textTheme.bodyLarge?.copyWith(
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
                          context.l10n.retry,
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
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.error,
                      fontWeight: FontWeight.w400,
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
}
