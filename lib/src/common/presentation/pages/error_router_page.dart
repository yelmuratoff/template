import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/localization/generated/l10n.dart';
import 'package:base_starter/src/features/home/presentation/page/home.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RouterErrorPage extends StatelessWidget {
  final String error;
  const RouterErrorPage({required this.error, super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(L10n.current.error),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText.rich(
                      TextSpan(
                        text: "${L10n.current.pageNotFound}: ",
                        children: [
                          TextSpan(
                            text: error,
                            style: context.theme.textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: " ${L10n.current.notFound}".toLowerCase(),
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: context.theme.textTheme.titleMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 16,
                      maxFontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                child: Text(L10n.current.backToHome),
                onPressed: () {
                  navigatorKey.currentContext?.goNamed(HomePage.name);
                },
              ),
            ),
            const Gap(50),
          ],
        ),
      );
}
