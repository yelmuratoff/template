part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent._();
}

final class UpdateThemeSettingsEvent extends SettingsEvent {
  const UpdateThemeSettingsEvent({required this.appTheme}) : super._();
  final AppTheme appTheme;

  @override
  List<Object> get props => [appTheme];
}

final class UpdateLocaleSettingsEvent extends SettingsEvent {
  const UpdateLocaleSettingsEvent({required this.locale}) : super._();
  final Locale locale;

  @override
  List<Object> get props => [locale];
}
