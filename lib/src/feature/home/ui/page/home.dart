import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/home/state/counter.dart';
import 'package:base_starter/src/feature/inspector/inspector_page.dart';
import 'package:base_starter/src/feature/settings/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

part 'view/home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String name = "Home";
  static const String routePath = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    fToast.init(navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) => HomeView(
        onSettingsPressed: () {
          context.pushNamed(SettingsPage.name);
        },
        onLoggerPressed: () {
          context.pushNamed(InspectorPage.name);
        },
      );
}
