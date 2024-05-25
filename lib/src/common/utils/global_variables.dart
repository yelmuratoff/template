import 'package:base_starter/src/common/utils/extensions/talker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talker/talker.dart';

/// This line declares a global variable which is used to show toast messages.
final FToast fToast = FToast();

/// This line declares a global key variable which is used to access the `NavigatorState` object associated with a widget.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> rootPageNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootPageNavigatorKey');

///  It is used to handle errors and log messages in the app.
final Talker talker = TalkerFlutter.init(
  settings: TalkerSettings(),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(),
  ),
);
