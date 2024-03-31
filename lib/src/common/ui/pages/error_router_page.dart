import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/home/ui/page/home.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

part 'view/error_page_view.dart';

class RouterErrorPage extends StatelessWidget {
  final String error;
  const RouterErrorPage({required this.error, super.key});

  @override
  Widget build(BuildContext context) => _RouterErrorView(
        error: error,
        onGoHomePressed: () =>
            navigatorKey.currentContext?.goNamed(HomePage.name),
      );
}
