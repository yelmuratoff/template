part of '../settings.dart';

class _AppVersionBody extends StatelessWidget {
  const _AppVersionBody({
    required this.onTapAppVersion,
    required Color versionTextColor,
  }) : _versionTextColor = versionTextColor;

  final void Function() onTapAppVersion;
  final Color _versionTextColor;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () {
              onTapAppVersion();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${L10n.current.appVersion}: ',
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    color: _versionTextColor,
                  ),
                ),
                Text(
                  context.dependencies.packageInfo.version,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    color: _versionTextColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${L10n.current.buildVersion}: ',
                style: context.theme.textTheme.titleSmall?.copyWith(
                  color: _versionTextColor,
                ),
              ),
              Text(
                context.dependencies.packageInfo.buildNumber,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  color: _versionTextColor,
                ),
              ),
            ],
          ),
        ],
      );
}
