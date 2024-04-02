import 'package:base_starter/src/feature/ispect/app_info/controller/controller.dart';
import 'package:base_starter/src/feature/ispect/app_info/widgets/device_info_body.dart';
import 'package:base_starter/src/feature/ispect/app_info/widgets/package_info_body.dart';
import 'package:flutter/material.dart';

part 'view/app_info_view.dart';

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
