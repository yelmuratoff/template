import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/feature/auth/bloc/auth_bloc.dart';
import 'package:base_starter/src/feature/home/ui/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view/auth_view.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const String name = "Auth";
  static const String routePath = "/auth";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) => const _AuthView();
}
