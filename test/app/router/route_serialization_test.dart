import 'package:base_starter/src/app/router/app_router_schema.dart';
import 'package:base_starter/src/app/router/routes/app_routes.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yx_navigation/yx_navigation.dart';

void main() {
  group('AppRouterSchema.serialization', () {
    const serialization = AppRouterSchema.serialization;
    const detail = YxRoute(id: 'detail');

    final detailTree = const YxRoute(id: 'app').toNode(
      children: [
        AppRoutes.root.toNode(),
        detail.toNode(arguments: {'id': '42'}),
      ],
    );

    test('writes the route tree into the URL path, not the fragment', () {
      final uri = serialization.convert(detailTree);

      check(uri.fragment).isEmpty();
      check(uri.pathSegments).contains(r'.detail$?id=42');
    });

    test('restores a route with arguments from its own URL', () {
      final restored = serialization.parse(serialization.convert(detailTree));

      final node = restored.children.last;
      check(node.route).equals(detail);
      check(node.arguments['id']).equals('42');
    });

    test('restores arguments the browser split off into the query string', () {
      final restored = serialization.parse(
        Uri.parse(r'/app/.root/.detail$?id=42'),
      );

      final node = restored.children.last;
      check(node.route).equals(detail);
      check(node.arguments['id']).equals('42');
    });

    test('leaves a URL without a query string untouched', () {
      final restored = serialization.parse(Uri.parse('/app/.root'));

      check(restored.children.last.route).equals(AppRoutes.root);
      check(restored.children.last.arguments).isEmpty();
    });
  });
}
