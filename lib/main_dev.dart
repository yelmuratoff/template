import 'package:base_starter/bootstrap.dart';

import 'package:base_starter/flavors.dart';

Future<void> main() async {
  F.appFlavor = Flavor.dev;
  await bootstrap();
}
