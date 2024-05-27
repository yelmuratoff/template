import 'package:flutter/material.dart';

/// A widget that displays a progress indicator.
/// You can easily customize it.
class AppLoaderIndicator extends StatelessWidget {
  const AppLoaderIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const RepaintBoundary(child: CircularProgressIndicator());
}
