import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/features/settings/domain/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/domain/theme/theme_repository.dart';
import 'package:base_starter/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:checks/checks.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocaleRepository extends Mock implements ILocaleRepository {}

class _MockThemeRepository extends Mock implements IThemeRepository {}

void main() {
  final lightTheme = AppTheme(mode: ThemeMode.light, seed: Colors.blue);
  final darkTheme = AppTheme(mode: ThemeMode.dark, seed: Colors.blue);
  const initialLocale = Locale('en');
  const nextLocale = Locale('ru');

  setUpAll(() {
    registerFallbackValue(lightTheme);
    registerFallbackValue(initialLocale);
  });

  group('SettingsBloc', () {
    late _MockLocaleRepository localeRepository;
    late _MockThemeRepository themeRepository;
    late SettingsBloc bloc;

    setUp(() {
      localeRepository = _MockLocaleRepository();
      themeRepository = _MockThemeRepository();
      bloc = SettingsBloc(
        localeRepository: localeRepository,
        themeRepository: themeRepository,
        initialState: IdleSettingsState(
          appTheme: lightTheme,
          locale: initialLocale,
        ),
      );
    });

    tearDown(() => bloc.close());

    Future<List<SettingsState>> recordStates(void Function() act) async {
      final states = <SettingsState>[];
      final sub = bloc.stream.listen(states.add);
      act();
      await pumpEventQueue();
      await sub.cancel();
      return states;
    }

    test('persists the theme and emits [Processing, Idle]', () async {
      when(() => themeRepository.setTheme(any())).thenAnswer((_) async {});

      final states = await recordStates(
        () => bloc.add(UpdateThemeSettingsEvent(appTheme: darkTheme)),
      );

      check(states.first).isA<ProcessingSettingsState>();
      check(states.last)
          .isA<IdleSettingsState>()
          .has((s) => s.appTheme, 'appTheme')
          .equals(darkTheme);
      verify(() => themeRepository.setTheme(darkTheme)).called(1);
    });

    test('emits [Processing, Error] when persisting the theme fails', () async {
      when(
        () => themeRepository.setTheme(any()),
      ).thenThrow(const CacheException(message: 'disk full'));

      final states = await recordStates(
        () => bloc.add(UpdateThemeSettingsEvent(appTheme: darkTheme)),
      );

      check(states.first).isA<ProcessingSettingsState>();
      check(states.last)
          .isA<ErrorSettingsState>()
          .has((s) => s.appTheme, 'appTheme')
          .equals(lightTheme);
    });

    test('persists the locale and emits [Processing, Idle]', () async {
      when(() => localeRepository.setLocale(any())).thenAnswer((_) async {});

      final states = await recordStates(
        () => bloc.add(const UpdateLocaleSettingsEvent(locale: nextLocale)),
      );

      check(states.first).isA<ProcessingSettingsState>();
      check(states.last)
          .isA<IdleSettingsState>()
          .has((s) => s.locale, 'locale')
          .equals(nextLocale);
      verify(() => localeRepository.setLocale(nextLocale)).called(1);
    });

    test(
      'emits [Processing, Error] when persisting the locale fails',
      () async {
        when(
          () => localeRepository.setLocale(any()),
        ).thenThrow(const CacheException(message: 'disk full'));

        final states = await recordStates(
          () => bloc.add(const UpdateLocaleSettingsEvent(locale: nextLocale)),
        );

        check(states.first).isA<ProcessingSettingsState>();
        check(states.last)
            .isA<ErrorSettingsState>()
            .has((s) => s.locale, 'locale')
            .equals(initialLocale);
      },
    );
  });
}
