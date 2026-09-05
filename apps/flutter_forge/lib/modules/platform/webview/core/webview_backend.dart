import 'package:flutter/widgets.dart';

enum WebEventKind { started, progress, finished, error }

class WebEvent {
  const WebEvent(this.kind, {this.url, this.progress = 0, this.message});
  final WebEventKind kind;
  final String? url;
  final double progress;
  final String? message;
}

bool isWebUrl(String value) {
  final uri = Uri.tryParse(value);
  return uri != null &&
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;
}

abstract class WebviewBackend {
  Stream<WebEvent> get events;
  Future<void> initialize();
  Widget buildView();
  Future<void> loadUrl(String url);
  Future<bool> canGoBack();
  Future<bool> canGoForward();
  Future<void> goBack();
  Future<void> goForward();
  Future<void> reload();
  Future<void> dispose();
}
