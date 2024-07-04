import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/features/home/presentation/home.dart';
import 'package:flutter/material.dart';

class RestartWrapper extends StatefulWidget {
  const RestartWrapper({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restartApp();
  }

  @override
  State createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWrapper> {
  Key _key = UniqueKey();

  void _restartApp() {
    setState(() {
      navigatorKey.currentContext?.goNamed(HomePage.name);
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) => KeyedSubtree(
        key: _key,
        child: widget.child,
      );
}
