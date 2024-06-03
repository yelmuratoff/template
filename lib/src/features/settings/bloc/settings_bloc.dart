import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/features/settings/data/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/data/theme/theme_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ILocaleRepository _localeRepo;
  final IThemeRepository _themeRepo;

  SettingsBloc({
    required ILocaleRepository localeRepository,
    required IThemeRepository themeRepository,
    required SettingsState initialState,
  })  : _localeRepo = localeRepository,
        _themeRepo = themeRepository,
        super(initialState) {
    on<SettingsEvent>((event, emit) async {
      if (event is UpdateThemeSettingsEvent) {
        await _updateTheme(event, emit);
      } else if (event is UpdateLocaleSettingsEvent) {
        await _updateLocale(event, emit);
      }
    });
  }

  Future<void> _updateTheme(
    UpdateThemeSettingsEvent event,
    Emitter<SettingsState> emitter,
  ) async {
    emitter(
      ProcessingSettingsState(
        appTheme: state.appTheme,
        locale: state.locale,
      ),
    );

    try {
      await _themeRepo.setTheme(event.appTheme);

      emitter(
        IdleSettingsState(appTheme: event.appTheme, locale: state.locale),
      );
    } catch (e) {
      emitter(
        ErrorSettingsState(
          appTheme: state.appTheme,
          locale: state.locale,
          cause: e,
        ),
      );
      rethrow;
    }
  }

  Future<void> _updateLocale(
    UpdateLocaleSettingsEvent event,
    Emitter<SettingsState> emitter,
  ) async {
    emitter(
      ProcessingSettingsState(
        appTheme: state.appTheme,
        locale: state.locale,
      ),
    );

    try {
      await _localeRepo.setLocale(event.locale);
      await L10n.load(event.locale);

      emitter(
        IdleSettingsState(appTheme: state.appTheme, locale: event.locale),
      );
    } catch (e) {
      emitter(
        ErrorSettingsState(
          appTheme: state.appTheme,
          locale: state.locale,
          cause: e,
        ),
      );
      rethrow;
    }
  }
}
