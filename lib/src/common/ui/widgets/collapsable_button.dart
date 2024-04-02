import 'dart:async';

import 'package:base_starter/src/app/router/router.dart';
import 'package:base_starter/src/common/services/router_service.dart';
import 'package:base_starter/src/common/ui/widgets/dialogs/toaster.dart';
import 'package:base_starter/src/common/utils/extensions/context_extension.dart';
import 'package:base_starter/src/common/utils/global_variables.dart';
import 'package:base_starter/src/feature/ispect/ispect_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// state for the invoker widget (defaults to alwaysOpened)
///
/// `alwaysOpened`:
/// This will force the the invoker widget to be opened always
///
/// `collapsible`:
/// This will make the widget to collapse and expand on demand
/// By default it will be in collapsed state
/// Tap or outwards will expand the widget
/// When expanded, tapping on it will navigate to Infospect screen.
/// And swiping it inwards will change it to collapsed state
///
/// `autoCollapse`: This will auto change the widget state from expanded to collapse after 5 seconds
/// By default it will be in collapsed state
/// Tap or outwards will expand the widget and if not tapped within 5 secs, it will change to
/// collapsed state.
/// When expanded, tapping on it will navigate to Infospect screen and will change it to
/// collapsed state
/// And swiping it inwards will change it to collapsed state
enum InvokerState { alwaysOpened, collapsible, autoCollapse }

/// A StatefulWidget that serves as a UI invoker for the Infospect tool.
/// Depending on the platform and configuration, it displays a floating action-like button
/// which when tapped or dragged can invoke the Infospect tool.
class InfospectInvoker extends StatefulWidget {
  const InfospectInvoker({
    required this.child,
    super.key,
    this.state = InvokerState.alwaysOpened,
    this.newWindowInDesktop = true,
  });

  final Widget child;
  final InvokerState state;
  final bool newWindowInDesktop;

  @override
  State<InfospectInvoker> createState() => _InfospectInvokerState();
}

/// This is the state associated with `InfospectInvoker`. It manages the display and behavior
/// of the invoker depending on its state and user interactions.
class _InfospectInvokerState extends State<InfospectInvoker> {
  double end = 0;
  late BorderRadiusGeometry borderRadius;
  late double width;
  Timer? timer;

  /// Sets the default visual properties of the invoker depending on its state.
  void initialValues({bool isInit = false}) {
    if (widget.state == InvokerState.alwaysOpened) {
      end = 2;
      borderRadius = BorderRadius.circular(16);
      width = 50;
    } else if (widget.state == InvokerState.autoCollapse ||
        widget.state == InvokerState.collapsible) {
      if (end == 0 && !isInit) return;
      end = 0;
      borderRadius = const BorderRadiusDirectional.only(
        topStart: Radius.circular(5),
        bottomStart: Radius.circular(5),
      );
      width = 5;
    }
    setState(() {});
  }

  /// Updates the invoker's visual properties to its expanded or 'open' state.
  void changedValues() {
    if (end == 2) return;
    end = 2;
    borderRadius = BorderRadius.circular(16);
    width = 50;
    setState(() {});
  }

  /// If the invoker's state is set to auto-collapse, this method starts a timer
  /// to auto-collapse the invoker after a certain duration.
  void startTimer() {
    if (widget.state == InvokerState.autoCollapse) {
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) => setState(initialValues),
      );
    }
  }

  @override
  void initState() {
    initialValues(isInit: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,
          ValueListenableBuilder<bool>(
            valueListenable: ValueNotifier(!context.config.isDev),
            builder: (context, value, child) {
              if (value) {
                return const SizedBox();
              } else {
                return child ?? const SizedBox();
              }
            },
            child: AnimatedPositionedDirectional(
              duration: const Duration(milliseconds: 300),
              bottom: 30,
              end: end,
              child: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    switch (widget.state) {
                      case InvokerState.collapsible ||
                            InvokerState.autoCollapse:
                        timer?.cancel();
                        if (details.delta.dx < 0) {
                          changedValues();
                          startTimer();
                        } else if (details.delta.dx > 0) {
                          initialValues();
                        }
                        break;

                      case InvokerState.alwaysOpened:
                        break;
                    }
                  },
                  onTap: () {
                    if (end == 0) {
                      switch (widget.state) {
                        case InvokerState.autoCollapse:
                          timer?.cancel();
                          changedValues();
                          startTimer();
                          break;

                        case InvokerState.collapsible ||
                              InvokerState.alwaysOpened:
                          changedValues();

                          break;
                      }
                    } else {
                      initialValues();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: TapRegion(
                      onTapOutside: (event) {
                        if (end != 0) {
                          initialValues();
                        }
                      },
                      onTapInside: (tap) {
                        _launchInfospect();
                        // if (end != 0) {
                        //   switch (widget.state) {
                        //     case InvokerState.autoCollapse:
                        //       initialValues();
                        //       _launchInfospect();
                        //       break;
                        //     case InvokerState.collapsible ||
                        //           InvokerState.alwaysOpened:
                        //       _launchInfospect();
                        //   }
                        // }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.primaryContainer,
                          borderRadius: borderRadius,
                        ),
                        height: 50,
                        width: width,
                        child: width == 50
                            ? const Icon(
                                Icons.monitor_heart,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Depending on the platform and the newWindowInDesktop flag,
  /// this method opens the Infospect tool in either the current window or a new one.
  void _launchInfospect() {
    if (end != 0) {
      if (routerService.currentRoute.contains("logger")) {
        Toaster.showToast(context, title: context.l10n.you_already_in_logger);
        return;
      } else {
        navigatorKey.currentContext?.pushNamed(ISpectPage.name);
      }
    }
  }
}
