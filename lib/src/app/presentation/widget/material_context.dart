import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/settings/presentation/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ispect/ispect.dart';

/// [MaterialContext] is an entry point to the material context.
/// This widget sets locales, themes and routing.
class MaterialContext extends ConsumerWidget {
  const MaterialContext({
    required this.routerConfig,
    super.key,
  });

  final RouterConfig<Object> routerConfig;

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return ISpectScopeWrapper(
      options: ISpectOptions(
        locale: locale,
      ),
      isISpectEnabled: F.isDev,
      child: MaterialApp.router(
        key: _globalKey,
        title: F.title,
        onGenerateTitle: (_) => F.title,
        debugShowCheckedModeBanner: false,
        theme: theme.lightTheme,
        darkTheme: theme.darkTheme,
        themeMode: theme.mode,
        localizationsDelegates: ISpectLocalizations.localizationDelegates([
          L10n.delegate,
        ]),
        supportedLocales: L10n.supportedLocales,
        locale: locale,
        routerConfig: routerConfig,
        builder: (context, child) {
          child = EasyLoading.init()(context, child);

          child = MediaQuery.withClampedTextScaling(
            minScaleFactor: 1,
            maxScaleFactor: 2,
            child: child,
          );

          child = Navigator(
            key: const ValueKey('ispect-navigator'),
            observers: [
              ISpectNavigatorObserver(),
            ],
            pages: [
              MaterialPage(
                child: ISpectBuilder(
                  child: child,
                ),
              ),
            ],
            onDidRemovePage: (_) {},
          );

          child = FToastBuilder()(context, child);

          if (F.isDev) {
            child = Banner(
              message: F.name,
              location: BannerLocation.topStart,
              color: Colors.red,
              child: child,
            );
          }
          return child;
        },
      ),
    );
  }
}
