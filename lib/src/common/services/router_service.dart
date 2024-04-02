RouterService routerService = RouterService.instance;

final class RouterService {
  late String _currentRoute;

  RouterService._privateConstructor();

  static final RouterService instance = RouterService._privateConstructor();

  Future<void> setRoute(String route) async {
    instance._currentRoute = route;
  }

  String get currentRoute => instance._currentRoute;
}
