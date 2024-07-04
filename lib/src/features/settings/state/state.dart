part of 'app_config.dart';

class AppConfigsState {
  const AppConfigsState({
    this.isPerformanceTrackingEnabled = false,
    this.isInspectorEnabled = false,
  });
  final bool isPerformanceTrackingEnabled;
  final bool isInspectorEnabled;

  AppConfigsState copyWith({
    bool? isPerformanceTrackingEnabled,
    bool? isInspectorEnabled,
  }) =>
      AppConfigsState(
        isPerformanceTrackingEnabled:
            isPerformanceTrackingEnabled ?? this.isPerformanceTrackingEnabled,
        isInspectorEnabled: isInspectorEnabled ?? this.isInspectorEnabled,
      );
}
