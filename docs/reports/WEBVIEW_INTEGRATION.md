# WebView source integration

Upstream: `lizy-coding/webview_plugin`, revision `1e160be430a55612bd1c1711f56be7ed94a4957b`.
Forge base: `25394f1`. Agent Hub task: `integrate-historical-webview-module`.

The project adapter freezes exact module, dependency, generated contract and test paths.
The external CLI Worker failed before changes because its version did not support the selected model.
The current session implements the same frozen task in the isolated managed checkout;
ScopeGuard and architecture review remain required before integration.

Ownership: `apps/flutter_forge/lib/modules/platform/webview`, route `/webview`.
Native backends: Android and Windows. Other platforms retain an unavailable catalog entry.
The historical wrapper source is adapted locally, with source provenance in `SOURCE.md`.
Teaching content uses Forge's shared learning scaffold. There is no nested application or business window.
URL inputs accept HTTP/HTTPS, Windows permission requests and popup windows are denied.
The 30-percent / 3-second reveal is a display heuristic, not successful-load evidence.
Windows progress remains estimated; native completion/error events provide final state.

Verification:
- Generated contracts: PASS (`agent_docs_valid:43`).
- Bare Flutter analysis: PASS.
- Complete quality gate: PASS, 6/6; existing five MEDIUM FlutterGuard findings remain.
- Tests cover URL rejection, dispose during initialization, retry after failure,
  loading reveal/completion, back/forward/reload, compact teaching UI and platform metadata.
- Android native integration: PASS on emulator-5554 (API 35, system WebView 124.0.6367.219); debug APK built and installed, all available modules including /webview opened and returned, both integration tests passed in 32 seconds. This traversal covers native initialization and route exit, not exhaustive browsing behavior.
- Windows native runtime: PENDING; no Windows host available in this session.

Windows requires WebView2 Runtime. No claim of Windows native acceptance is made from macOS tests.
