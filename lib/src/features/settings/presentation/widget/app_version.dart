part of '../settings_screen.dart';

class _AppVersionBody extends StatelessWidget {
  const _AppVersionBody({
    required this.onTapAppVersion,
    required Color versionTextColor,
  }) : _versionTextColor = versionTextColor;

  final VoidCallback onTapAppVersion;
  final Color _versionTextColor;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: onTapAppVersion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${L10n.current.appVersion}: ',
                  style: context.textStyles.s16w500.copyWith(
                    color: _versionTextColor,
                  ),
                ),
                Text(
                  context.dependencies.packageInfo.version,
                  style: context.textStyles.s16w500.copyWith(
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
                style: context.textStyles.s16w500.copyWith(
                  color: _versionTextColor,
                ),
              ),
              Text(
                context.dependencies.packageInfo.buildNumber,
                style: context.textStyles.s16w500.copyWith(
                  color: _versionTextColor,
                ),
              ),
            ],
          ),
        ],
      );
}
