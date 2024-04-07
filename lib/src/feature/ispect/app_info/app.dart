import 'dart:io';

import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'controller/controller.dart';
part 'view/app_info_view.dart';
part 'widgets/device_info_body.dart';
part 'widgets/package_info_body.dart';
part 'widgets/key_value_line.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  final _contorller = AppInfoController();

  @override
  void initState() {
    _contorller.loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _AppInfoView(
        controller: _contorller,
      );
}
