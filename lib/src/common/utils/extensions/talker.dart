import 'dart:developer' as dev;

import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

/// Talker extension for Flutter
extension TalkerFlutter on Talker {
  static Talker init({
    TalkerLogger? logger,
    TalkerObserver? observer,
    TalkerSettings? settings,
    TalkerFilter? filter,
  }) =>
      Talker(
        logger: (logger ?? TalkerLogger()).copyWith(
          output: _defaultFlutterOutput,
        ),
        settings: settings,
        observer: observer,
        filter: filter,
      );

  static dynamic _defaultFlutterOutput(String message) {
    if (kIsWeb) {
      debugPrint(message);
      return;
    }
    if ([TargetPlatform.iOS, TargetPlatform.macOS]
        .contains(defaultTargetPlatform)) {
      dev.log(message, name: 'ϟ ${AppConstants.appName}');
      return;
    }
    debugPrint(message);
  }
}
