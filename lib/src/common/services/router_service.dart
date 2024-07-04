/// `RouterService` - This class is responsible for handling the app routing.
final class RouterService {
  RouterService._privateConstructor();
  late String _currentRoute;

  static final RouterService instance = RouterService._privateConstructor();

  static Future<void> setRoute(String route) async {
    instance._currentRoute = route;
  }

  String get currentRoute => instance._currentRoute;
}
