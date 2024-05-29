import 'package:flutter/material.dart';

/// A widget that displays a progress indicator.
/// You can easily customize it.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const RepaintBoundary(child: CircularProgressIndicator());
}
