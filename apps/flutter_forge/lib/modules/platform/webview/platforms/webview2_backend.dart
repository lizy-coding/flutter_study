import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:webview_windows/webview_windows.dart';
import '../core/webview_backend.dart';

class WebView2Backend implements WebViewBackend {
  final _controller = WebviewController();
  final _events = StreamController<WebViewEvent>.broadcast();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  bool _disposed = false;
  bool _ready = false;
  bool _back = false;
  bool _forward = false;
  String _url = '';
  Timer? _progressTimer;
  @override
  Stream<WebViewEvent> get events => _events.stream;
  void _emit(WebViewEvent e) {
    if (!_disposed) _events.add(e);
  }

  @override
  Future<void> initialize() async {
    await _controller.initialize();
    if (_disposed) {
      await _controller.dispose();
      return;
    }
    _ready = true;
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    if (_disposed) return;
    _subscriptions.add(
      _controller.url.listen((url) {
        _url = url;
      }),
    );
    _subscriptions.add(
      _controller.historyChanged.listen((history) {
        _back = history.canGoBack;
        _forward = history.canGoForward;
      }),
    );
    _subscriptions.add(
      _controller.onLoadError.listen((error) {
        _progressTimer?.cancel();
        _emit(WebViewEvent(WebViewEventKind.error, message: error.name));
      }),
    );
    _subscriptions.add(
      _controller.loadingState.listen((state) {
        _progressTimer?.cancel();
        if (state == LoadingState.loading) {
          _emit(WebViewEvent(WebViewEventKind.started, url: _url));
          double progress = 0.1;
          _progressTimer = Timer.periodic(const Duration(milliseconds: 200), (
            timer,
          ) {
            progress = (progress + 0.03).clamp(0, 0.95);
            _emit(WebViewEvent(WebViewEventKind.progress, progress: progress));
            if (progress >= 0.95) timer.cancel();
          });
        } else if (state == LoadingState.navigationCompleted) {
          _emit(WebViewEvent(WebViewEventKind.finished, url: _url));
        }
      }),
    );
  }

  @override
  Widget buildView() => Webview(
    _controller,
    permissionRequested: (url, kind, initiated) async =>
        WebviewPermissionDecision.deny,
  );
  @override
  Future<void> loadUrl(String url) {
    _url = url;
    return _controller.loadUrl(url);
  }

  @override
  Future<bool> canGoBack() async => _back;
  @override
  Future<bool> canGoForward() async => _forward;
  @override
  Future<void> goBack() => _controller.goBack();
  @override
  Future<void> goForward() => _controller.goForward();
  @override
  Future<void> reload() => _controller.reload();
  @override
  Future<void> dispose() async {
    _disposed = true;
    _progressTimer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    if (_ready) await _controller.dispose();
    await _events.close();
  }
}
