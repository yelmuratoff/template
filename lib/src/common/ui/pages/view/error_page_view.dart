part of '../error_router_page.dart';

class _RouterErrorView extends StatelessWidget {
  final String error;
  final void Function() onGoHomePressed;
  const _RouterErrorView({
    required this.error,
    required this.onGoHomePressed,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.error),
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
                        text: "${context.l10n.page_not_found}: ",
                        children: [
                          TextSpan(
                            text: error,
                            style: context.theme.textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text:
                                    " ${context.l10n.not_found}".toLowerCase(),
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
                child: Text(context.l10n.go_to_home),
                onPressed: () {
                  onGoHomePressed();
                },
              ),
            ),
            const Gap(50),
          ],
        ),
      );
}
