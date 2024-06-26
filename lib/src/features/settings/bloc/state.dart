part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  final Locale? locale;
  final AppTheme? appTheme;

  const SettingsState({this.locale, this.appTheme});

  @override
  List<Object?> get props => [locale, appTheme];
}

class IdleSettingsState extends SettingsState {
  const IdleSettingsState({super.locale, super.appTheme});
}

class ProcessingSettingsState extends SettingsState {
  const ProcessingSettingsState({super.locale, super.appTheme});
}

class ErrorSettingsState extends SettingsState {
  final Object cause;

  const ErrorSettingsState({
    required this.cause,
    super.locale,
    super.appTheme,
  });

  @override
  List<Object?> get props => [cause, locale, appTheme];
}
