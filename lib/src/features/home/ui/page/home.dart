import 'package:base_starter/src/app/router/extras.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/extensions/string_extension.dart';
import 'package:base_starter/src/features/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/features/home/state/counter.dart';
import 'package:base_starter/src/features/settings/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) => HomeView(
        onSettingsPressed: () {
          context.pushNamed(
            SettingsPage.name,
            queryParameters: {
              ExtraKeys.title: context.l10n.settings,
            },
          );
        },
      );
}
