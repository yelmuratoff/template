import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/initialization/model/environment_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// `initHandling` - This function initializes handling of the app.
Future<void> initHandling() async {
  FlutterError.presentError = (details) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      talker.handle(details, details.stack);
    });
  };

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
    ),
  );

  PlatformDispatcher.instance.onError = (error, stack) {
    if (EnvironmentStore.environment.value == "PROD" && kDebugMode == false) {
      // FirebaseCrashlytics.instance.recordError(error, stack);
    }
    talker.handle(error, stack);
    return true;
  };

  FlutterError.onError = (details) {
    if (EnvironmentStore.environment.value == "PROD" && kDebugMode == false) {
      // FirebaseCrashlytics.instance
      //     .recordError(details.exception, details.stack),
    }
    talker.handle(details, details.stack);
  };
}

/// `GoodLog` - This class contains the basic structure of the log.
class GoodLog extends TalkerLog {
  GoodLog(String super.message);

  /// Your custom log title
  @override
  String get title => 'good';

  /// Your custom log color
  @override
  AnsiPen get pen => AnsiPen()..xterm(121);
}

/// `RouteLog` - This class contains the route log.
class RouteLog extends TalkerLog {
  RouteLog(String super.message);

  /// Your custom log title
  @override
  String get title => 'route';

  /// Your custom log color
  @override
  AnsiPen get pen => AnsiPen()..rgb(r: 0.5, g: 0.5);
}

/// `ProviderLog` - This class contains the provider log.

class ProviderLog extends TalkerLog {
  ProviderLog(String super.message);

  /// Your custom log title
  @override
  String get title => 'provider';

  /// Your custom log color
  @override
  AnsiPen get pen => AnsiPen()..rgb(r: 0.2, g: 0.8, b: 0.9);
}

AnsiPen getAnsiPenFromColor(Color color) =>
    AnsiPen()..rgb(r: color.red, g: color.green, b: color.blue);
