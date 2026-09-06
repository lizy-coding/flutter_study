# Source provenance

Integrated from https://github.com/lizy-coding/webview_plugin at commit
1e160be430a55612bd1c1711f56be7ed94a4957b (package name: webview_continer).
Source snapshot was downloaded before integration.

The src Android/Windows backends, unified controller operations and loading manager
were adapted into this Forge-owned module. Duplicate legacy wrappers and standalone
application hosts are not retained. Navigation controls, the 30% / 3-second reveal,
300ms fade and Windows estimated progress retain the original behavior.
Windows now uses native loading events instead of a page-injected message listener.
Subscriptions, timers and asynchronous shutdown are owned by the module session.
No external repository dependency remains for this wrapper; platform engines remain
normal pub dependencies. Upstream did not include a LICENSE file in this snapshot.

Forge now also enables macOS through the registered webview_flutter WKWebView
implementation. Android and macOS share WebViewFlutterBackend; Windows retains
its WebView2 backend. This is a Forge extension beyond the original wrapper's
Android/Windows platform selector.
