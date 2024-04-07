import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';
import 'package:ispect/ispect_page.dart';
import 'package:ispect/src/common/extensions/context.dart';
import 'package:ispect/src/core/localization/localization.dart';

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
class DraggableButton extends StatefulWidget {
  final Widget child;
  final InvokerState state;
  final bool newWindowInDesktop;
  final ISpectOptions options;
  final GlobalKey<NavigatorState> navigatorKey;

  const DraggableButton({
    required this.child,
    required this.navigatorKey,
    super.key,
    this.state = InvokerState.autoCollapse,
    this.newWindowInDesktop = true,
    required this.options,
  });

  @override
  State<DraggableButton> createState() => _InfospectInvokerState();
}

class _InfospectInvokerState extends State<DraggableButton> {
  double xPos = 0.0;
  double yPos = 600.0;
  bool isCollapsed = false;
  Timer? collapseTimer;
  bool inLoggerPage = false;

  @override
  void initState() {
    super.initState();
    if (widget.state == InvokerState.autoCollapse) {
      startAutoCollapseTimer();
    }
  }

  void startAutoCollapseTimer() {
    cancelAutoCollapseTimer();
    collapseTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isCollapsed = true;
      });
    });
  }

  void cancelAutoCollapseTimer() => collapseTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Localizations(
      locale: widget.options.locale,
      delegates: Localization.localizationDelegates,
      child: _ButtonView(
        onTap: () {
          if (widget.state != InvokerState.alwaysOpened) {
            setState(() {
              if (!isCollapsed) {
                isCollapsed = true;
                if (widget.state == InvokerState.autoCollapse) {
                  startAutoCollapseTimer();
                }
              }
            });
          }
        },
        xPos: xPos,
        yPos: yPos,
        screenWidth: screenWidth,
        onPanUpdate: (DragUpdateDetails details) {
          if (!isCollapsed) {
            setState(() {
              xPos += details.delta.dx;
              yPos += details.delta.dy;
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          if (!isCollapsed) {
            final screenWidth = MediaQuery.of(context).size.width;
            const buttonWidth = 50;

            final halfScreenWidth = screenWidth / 2;
            double targetXPos;

            if (xPos + buttonWidth / 2 < halfScreenWidth) {
              targetXPos = 0;
            } else {
              targetXPos = screenWidth - buttonWidth;
            }

            setState(() {
              xPos = targetXPos;
            });

            if (widget.state == InvokerState.autoCollapse) {
              startAutoCollapseTimer();
            }
          }
        },
        onButtonTap: () {
          setState(() {
            isCollapsed = !isCollapsed;
            if (isCollapsed) {
              cancelAutoCollapseTimer();
              _launchInfospect();
            } else if (widget.state == InvokerState.autoCollapse) {
              startAutoCollapseTimer();
            }
          });
        },
        isCollapsed: isCollapsed,
        inLoggerPage: inLoggerPage,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    collapseTimer?.cancel();
    super.dispose();
  }

  void _launchInfospect() {
    final BuildContext? context = widget.navigatorKey.currentContext;
    if (isCollapsed && context != null) {
      if (inLoggerPage) {
        Navigator.pop(context);
      } else {
        Navigator.push(
          widget.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => ISpectPage(
              options: widget.options,
            ),
          ),
        ).then((value) {
          setState(() {
            inLoggerPage = false;
          });
        });
        setState(() {
          inLoggerPage = true;
        });
      }
    }
  }
}

class _ButtonView extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  final double xPos;
  final double yPos;
  final double screenWidth;
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(DragEndDetails) onPanEnd;
  final Function() onButtonTap;
  final bool isCollapsed;
  final bool inLoggerPage;
  const _ButtonView({
    required this.onTap,
    required this.child,
    required this.xPos,
    required this.yPos,
    required this.screenWidth,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onButtonTap,
    required this.isCollapsed,
    required this.inLoggerPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Stack(
        children: [
          child,
          Positioned(
            top: yPos,
            left: (xPos < 50) ? xPos : null,
            right: (xPos > 50) ? screenWidth - xPos - 50 : null,
            child: GestureDetector(
              onPanUpdate: (details) {
                onPanUpdate.call(details);
              },
              onPanEnd: (details) {
                onPanEnd.call(details);
              },
              onTap: () {
                onButtonTap.call();
              },
              child: AnimatedContainer(
                width: isCollapsed ? 50 * 0.2 : 50,
                height: 50,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: context.ispectTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: !isCollapsed
                    ? inLoggerPage
                        ? const Icon(
                            Icons.undo_rounded,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.monitor_heart,
                            color: Colors.white,
                          )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
