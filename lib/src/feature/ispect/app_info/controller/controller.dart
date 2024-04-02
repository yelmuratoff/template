import 'dart:io';

import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoController extends ChangeNotifier {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;
  PackageInfo? _packageInfo;

  PackageInfo? get packageInfo => _packageInfo;
  IosDeviceInfo? get iosDeviceInfo => _iosDeviceInfo;
  AndroidDeviceInfo? get androidDeviceInfo => _androidDeviceInfo;

  Future<void> loadAll() async {
    try {
      await _loadPackageInfo();
      if (Platform.isIOS) {
        _iosDeviceInfo = await _deviceInfo.iosInfo;
      } else if (Platform.isAndroid) {
        _androidDeviceInfo = await _deviceInfo.androidInfo;
      }
    } on Exception catch (e, st) {
      talker.handle(e, st);
      await Toaster.showErrorToast(
        navigatorKey.currentContext!,
        title: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> _loadPackageInfo() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      notifyListeners();
    } on Exception catch (e, st) {
      talker.handle(e, st);
      await Toaster.showErrorToast(
        navigatorKey.currentContext!,
        title: e.toString(),
      );
    }
  }
}
