// lib/env/env.dart
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'API_URL', useConstantCase: true)
  static const String apiUrl = _Env.apiUrl;
}
