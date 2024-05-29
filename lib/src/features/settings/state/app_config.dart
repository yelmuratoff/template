import 'dart:async';

import 'package:base_starter/src/common/configs/preferences/app_config_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class AppConfigs extends StateNotifier<AppConfigsState> {
  AppConfigs() : super(const AppConfigsState()) {
    _init();
  }

  Future<void> _init() async {
    final isTrackingEnabled =
        AppConfigManager.instance.isPerformanceTrackingEnabled;
    state = state.copyWith(isPerformanceTrackingEnabled: isTrackingEnabled);
  }

  Future<void> setPerformanceTracking({required bool value}) async {
    await AppConfigManager.instance.setPerformanceTracking(value: value);
    state = state.copyWith(isPerformanceTrackingEnabled: value);
  }

  Future<void> setInspector({required bool value}) async {
    state = state.copyWith(isInspectorEnabled: value);
  }

  bool isPerformanceTrackingEnabled() => state.isPerformanceTrackingEnabled;

  bool isInspectorEnabled() => state.isInspectorEnabled;
}
