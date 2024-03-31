part of '../splash.dart';

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) => Image.asset(
        Assets.images.splash.path,
        fit: BoxFit.cover,
      );
}
