import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/webview_backend.dart';

class AndroidWebviewBackend implements WebviewBackend {
  final _events = StreamController<WebEvent>.broadcast();
  WebViewController? _controller;
  bool _disposed = false;
  @override
  Stream<WebEvent> get events => _events.stream;
  void _emit(WebEvent event) {
    if (!_disposed) _events.add(event);
  }

  @override
  Future<void> initialize() async {
    final controller = WebViewController();
    _controller = controller;
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    if (_disposed) return;
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) => isWebUrl(request.url)
            ? NavigationDecision.navigate
            : NavigationDecision.prevent,
        onPageStarted: (url) => _emit(WebEvent(WebEventKind.started, url: url)),
        onProgress: (progress) =>
            _emit(WebEvent(WebEventKind.progress, progress: progress / 100)),
        onPageFinished: (url) =>
            _emit(WebEvent(WebEventKind.finished, url: url)),
        onWebResourceError: (error) {
          if (error.isForMainFrame != false) {
            _emit(WebEvent(WebEventKind.error, message: error.description));
          }
        },
      ),
    );
  }

  @override
  Widget buildView() => WebViewWidget(controller: _controller!);
  @override
  Future<void> loadUrl(String url) => _controller!.loadRequest(Uri.parse(url));
  @override
  Future<bool> canGoBack() => _controller!.canGoBack();
  @override
  Future<bool> canGoForward() => _controller!.canGoForward();
  @override
  Future<void> goBack() => _controller!.goBack();
  @override
  Future<void> goForward() => _controller!.goForward();
  @override
  Future<void> reload() => _controller!.reload();
  @override
  Future<void> dispose() async {
    _disposed = true;
    // webview_flutter owns native disposal through WebViewWidget unmount.
    await _events.close();
  }
}
