import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge_app/app/router/app_route_table.dart';
import 'package:flutter_forge_app/module_registry/module_catalog_utils.dart';
import 'package:flutter_forge_app/modules/platform/webview/module_root.dart';
import 'webview_session_test.dart' show FakeWebviewBackend;

void main() {
  test('catalog restricts WebView to historical native backends', () {
    final module = AppRouteTable.modules.singleWhere(
      (m) => m.path == '/webview',
    );
    expect(isModuleAvailable(module, TargetPlatform.android), isTrue);
    expect(isModuleAvailable(module, TargetPlatform.windows), isTrue);
    expect(isModuleAvailable(module, TargetPlatform.macOS), isFalse);
    expect(isModuleAvailable(module, TargetPlatform.iOS), isFalse);
  });
  testWidgets(
    'teaching page fits compact viewport and rejects invalid navigation',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final backend = FakeWebviewBackend();
      await tester.pumpWidget(MaterialApp(home: WebviewPage(backend: backend)));
      await tester.pump();
      expect(find.text('网页容器与跨平台导航'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('webview-url')),
        'javascript:alert(1)',
      );
      await tester.tap(find.text('打开'));
      await tester.pump();
      expect(find.byKey(const ValueKey('webview-error')), findsOneWidget);
      expect(backend.calls, ['https://example.com']);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      expect(backend.disposed, isTrue);
    },
  );
}
