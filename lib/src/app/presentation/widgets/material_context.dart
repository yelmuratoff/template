import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/app/router/app_router_schema.dart';
import 'package:base_starter/src/common/presentation/widgets/toaster/flutter_toast.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ispect/ispect.dart';
import 'package:yx_navigation_flutter/yx_navigation_flutter.dart';

/// [MaterialContext] is an entry point to the material context.
/// This widget sets locales, themes and routing.
class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  final _observer = ISpectNavigatorObserver();
  late final YxRouterConfig _routerConfig;

  @override
  void initState() {
    super.initState();
    _routerConfig = AppRouterSchema().build(
      stateManagerConfiguration: StateManagerConfiguration(
        stateManager: context.dependencies.navigationManager.stateManager,
      ),
      navigatorConfiguration: NavigatorConfiguration(
        navigatorObservers: ISpectNavigatorObserver.observers(
          observer: _observer,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _routerConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return MaterialApp.router(
      title: F.title,
      onGenerateTitle: (_) => F.title,
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,

      localizationsDelegates: [
        ...L10n.delegates,
        ...ISpectLocalizations.delegate(),
      ],
      supportedLocales: L10n.supportedLocales,
      locale: locale,
      routerConfig: _routerConfig,
      builder: (context, child) {
        var wrapped = EasyLoading.init()(context, child);

        wrapped = MediaQuery.withClampedTextScaling(
          minScaleFactor: 1,
          maxScaleFactor: 2,
          child: wrapped,
        );

        wrapped = ISpectBuilder.wrap(
          options: ISpectOptions(locale: locale, observer: _observer),
          isISpectEnabled: F.isDev,
          child: wrapped,
        );

        wrapped = FToastBuilder()(context, wrapped);

        if (F.isDev) {
          wrapped = Banner(
            message: F.name,
            location: BannerLocation.topStart,
            color: Colors.red,
            child: wrapped,
          );
        }
        return wrapped;
      },
    );
  }
}
