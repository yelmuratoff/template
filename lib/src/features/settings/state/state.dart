part of 'app_config.dart';

class AppConfigsState {
  final bool isPerformanceTrackingEnabled;
  final bool isInspectorEnabled;

  const AppConfigsState({
    this.isPerformanceTrackingEnabled = false,
    this.isInspectorEnabled = false,
  });

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
