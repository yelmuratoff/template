/// `RouterService` - This class is responsible for handling the app routing.
final class RouterService {
  late String _currentRoute;

  RouterService._privateConstructor();

  static final RouterService instance = RouterService._privateConstructor();

  static Future<void> setRoute(String route) async {
    instance._currentRoute = route;
  }

  String get currentRoute => instance._currentRoute;
}
