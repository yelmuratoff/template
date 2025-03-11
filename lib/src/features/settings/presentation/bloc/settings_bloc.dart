import 'package:base_starter/src/app/model/app_theme.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/settings/domain/locale/locale_repository.dart';
import 'package:base_starter/src/features/settings/domain/theme/theme_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required ILocaleRepository localeRepository,
    required IThemeRepository themeRepository,
    required SettingsState initialState,
  })  : _localeRepo = localeRepository,
        _themeRepo = themeRepository,
        super(initialState) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        final UpdateThemeSettingsEvent e => _updateTheme(e, emit),
        final UpdateLocaleSettingsEvent e => _updateLocale(e, emit),
      },
    );
  }
  final ILocaleRepository _localeRepo;
  final IThemeRepository _themeRepo;

  Future<void> _updateTheme(
    UpdateThemeSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(
      ProcessingSettingsState(
        appTheme: state.appTheme,
        locale: state.locale,
      ),
    );

    try {
      await _themeRepo.setTheme(event.appTheme);

      emit(
        IdleSettingsState(
          appTheme: event.appTheme,
          locale: state.locale,
        ),
      );
    } catch (e) {
      emit(
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
    Emitter<SettingsState> emit,
  ) async {
    emit(
      ProcessingSettingsState(
        appTheme: state.appTheme,
        locale: state.locale,
      ),
    );

    try {
      await _localeRepo.setLocale(event.locale);
      L10n.load(event.locale);

      emit(
        IdleSettingsState(
          appTheme: state.appTheme,
          locale: event.locale,
        ),
      );
    } catch (e) {
      emit(
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
