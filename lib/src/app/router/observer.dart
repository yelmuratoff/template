import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';

/// Router observer to log all the navigation actions
class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      talkerWrapper.route(
        'Route action: didPush \n Route name: ${route.settings.name} \n Previous route name: ${previousRoute?.settings.name} \n Arguments ${route.settings.arguments}',
      );
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      talkerWrapper.route(
        'Route action: didPop \n Route: ${previousRoute?.settings.name} \n Previous route name: ${route.settings.name}',
      );
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    talkerWrapper.route(
      'Route action: didRemove \n Removed route name: ${route.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    talkerWrapper.route(
      'Route action: didReplace \n Route: ${newRoute?.settings.name} \n Previous route name: ${oldRoute?.settings.name}',
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);
    talkerWrapper.route(
      'Route action: didStartUserGesture \n Route: ${route.settings.name} \n Previous route name: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    talkerWrapper.route('Route action: didStopUserGesture');
  }
}
