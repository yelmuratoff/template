import 'package:base_starter/flavors.dart';
import 'package:base_starter/src/app/router/guards/tab.dart';
import 'package:base_starter/src/app/router/routes/router.dart';
import 'package:base_starter/src/common/presentation/screens/error_router_screen.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/utils.dart';
import 'package:base_starter/src/core/l10n/localization.dart';
import 'package:base_starter/src/features/auth/presentation/bloc/user/user_cubit.dart';
import 'package:base_starter/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ispect/ispect.dart';
import 'package:octopus/octopus.dart';

/// [MaterialContext] is an entry point to the material context.
/// This widget sets locales, themes and routing.
class MaterialContext extends StatefulWidget {
  const MaterialContext({
    super.key,
  });

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final Octopus _router;

  final observer = ISpectNavigatorObserver();

  @override
  void initState() {
    super.initState();

    _router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.splash,
      observers: [
        observer,
      ],
      guards: [
        TabGuard(),
      ],
      onError: (error, stackTrace) {},
      notFound: (ctx, name, arguments) => RouterErrorScreen(
        error: 'Route not found: $name with arguments: $arguments',
      ),
    );

    final routes = _router.config.routes
        .map((key, value) => MapEntry(key, value.toString()));

    ISpect.route('📜 Routes:\n${AppUtils.formatPrettyJson(routes)}');

    context.blocRead<UserCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return ISpectScopeWrapper(
      options: ISpectOptions(
        locale: locale,
      ),
      isISpectEnabled: F.isDev,
      child: MaterialApp.router(
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
        routerConfig: _router.config,
        builder: (context, child) {
          child = EasyLoading.init()(context, child);

          child = MediaQuery.withClampedTextScaling(
            minScaleFactor: 1,
            maxScaleFactor: 2,
            child: child,
          );

          child = ISpectBuilder(
            observer: observer,
            child: child,
          );

          child = OctopusTools(
            enable: F.isDev,
            child: child,
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
