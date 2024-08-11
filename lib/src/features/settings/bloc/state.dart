part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState({this.locale, this.appTheme});
  final Locale? locale;
  final AppTheme? appTheme;

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
  const ErrorSettingsState({
    required this.cause,
    super.locale,
    super.appTheme,
  });
  final Object cause;

  @override
  List<Object?> get props => [cause, locale, appTheme];
}
