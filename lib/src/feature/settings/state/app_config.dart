import 'package:base_starter/src/common/services/app_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfigsState with _$AppConfigsState {
  const factory AppConfigsState({
    @Default(false) bool isPerformanceTrackingEnabled,
  }) = _AppConfigsState;
}

@riverpod
class AppConfigs extends _$AppConfigs {
  @override
  AppConfigsState build() {
    final isTrackingEnabled = AppConfigsService.isPerformanceTrackingEnabled;
    return AppConfigsState(isPerformanceTrackingEnabled: isTrackingEnabled);
  }

  Future<void> setPerformanceTracking({required bool value}) async {
    await AppConfigsService.setPerformanceTracking(value: value);
    state = state.copyWith(isPerformanceTrackingEnabled: value);
  }

  bool isPerformanceTrackingEnabled() => state.isPerformanceTrackingEnabled;
}
