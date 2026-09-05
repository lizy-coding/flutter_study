import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge_app/modules/platform/webview/core/webview_backend.dart';
import 'package:flutter_forge_app/modules/platform/webview/core/webview_session.dart';

class FakeWebviewBackend implements WebviewBackend {
  final controller = StreamController<WebEvent>.broadcast(sync: true);
  Completer<void>? initialization;
  bool disposed = false;
  bool fail = false;
  final List<String> calls = [];
  @override
  Stream<WebEvent> get events => controller.stream;
  @override
  Future<void> initialize() async {
    await initialization?.future;
    if (fail) throw StateError('init failed');
  }

  @override
  Widget buildView() => const Text('native view substitute');
  @override
  Future<void> loadUrl(String url) async {
    calls.add(url);
  }

  @override
  Future<bool> canGoBack() async => true;
  @override
  Future<bool> canGoForward() async => true;
  @override
  Future<void> goBack() async {
    calls.add('back');
  }

  @override
  Future<void> goForward() async {
    calls.add('forward');
  }

  @override
  Future<void> reload() async {
    calls.add('reload');
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await controller.close();
  }
}

void main() {
  test(
    'rejects executable and malformed URLs before native navigation',
    () async {
      final backend = FakeWebviewBackend();
      final session = WebviewSession(backend);
      await session.start();
      final count = backend.calls.length;
      for (final url in [
        'javascript:alert(1)',
        'file:///etc/passwd',
        'https://',
        'https://user:pass@example.com',
      ]) {
        await session.navigate(url);
        expect(session.error, isNotNull);
      }
      expect(backend.calls.length, count);
      session.dispose();
    },
  );
  test('late initialization never navigates after disposal', () async {
    final backend = FakeWebviewBackend()..initialization = Completer<void>();
    final session = WebviewSession(backend);
    final pending = session.start();
    session.dispose();
    backend.initialization!.complete();
    await pending;
    expect(backend.calls, isEmpty);
    expect(backend.disposed, isTrue);
  });
  test('reports initialization failure and allows retry', () async {
    final backend = FakeWebviewBackend()..fail = true;
    final session = WebviewSession(backend);
    await session.start();
    expect(session.error, contains('init failed'));
    backend.fail = false;
    await session.start();
    expect(session.initialized, isTrue);
    session.dispose();
  });
  testWidgets('threshold, timeout, completion and navigation remain distinct', (
    tester,
  ) async {
    final backend = FakeWebviewBackend();
    final session = WebviewSession(backend);
    await session.start();
    backend.controller.add(const WebEvent(WebEventKind.progress, progress: .3));
    expect(session.contentVisible, isTrue);
    expect(session.loading, isTrue);
    await session.reload();
    await tester.pump(const Duration(seconds: 3));
    expect(session.contentVisible, isTrue);
    expect(session.loading, isTrue);
    backend.controller.add(const WebEvent(WebEventKind.finished));
    await tester.pump();
    expect(session.canBack, isTrue);
    expect(session.loading, isFalse);
    await session.back();
    await session.forward();
    expect(backend.calls, containsAll(['reload', 'back', 'forward']));
    session.dispose();
  });
}
