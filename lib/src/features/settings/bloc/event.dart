part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent._();
}

final class UpdateThemeSettingsEvent extends SettingsEvent {
  final AppTheme appTheme;

  const UpdateThemeSettingsEvent({required this.appTheme}) : super._();

  @override
  List<Object> get props => [appTheme];
}

final class UpdateLocaleSettingsEvent extends SettingsEvent {
  final Locale locale;

  const UpdateLocaleSettingsEvent({required this.locale}) : super._();

  @override
  List<Object> get props => [locale];
}
