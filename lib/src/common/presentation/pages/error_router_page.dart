import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RouterErrorPage extends StatelessWidget {
  const RouterErrorPage({required this.error, super.key});
  final String error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.current.error,
          ),
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
                        text: '${L10n.current.pageNotFound}: ',
                        children: [
                          TextSpan(
                            text: error,
                            style: context.textStyles.s18w600,
                            children: [
                              TextSpan(
                                text: ' ${L10n.current.notFound}'.toLowerCase(),
                                style: context.textStyles.s18w600.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: context.textStyles.s18w600,
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
                child: Text(
                  L10n.current.backToHome,
                ),
                onPressed: () {
                  const HomeRoute().go(navigatorKey.currentContext ?? context);
                },
              ),
            ),
            const Gap(50),
          ],
        ),
      );
}
