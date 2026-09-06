# WebView source integration

Upstream: `lizy-coding/webview_plugin`, revision `1e160be430a55612bd1c1711f56be7ed94a4957b`.
Forge base: `25394f1`. Agent Hub task: `integrate-historical-webview-module`.

The project adapter freezes exact module, dependency, generated contract and test paths.
The external CLI Worker failed before changes because its version did not support the selected model.
The current session implements the same frozen task in the isolated managed checkout;
ScopeGuard and architecture review remain required before integration.

Ownership: `apps/flutter_forge/lib/modules/platform/webview`, route `/webview`.
Native backends: Android, macOS and Windows. Other platforms retain an unavailable catalog entry.
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

## macOS adaptation

Android and macOS share `WebViewFlutterBackend`, using webview_flutter's registered
Android WebView / WKWebView implementation. The generated catalog now enables macOS;
the application already has network-client entitlements and a macOS 12 deployment target.
The original Android-only class/file name was replaced to reflect shared ownership.

Candidate validation: full quality gate 6/6 PASS using a temporary Git index (the
user's staging area was not changed); platform catalog and lifecycle tests PASS.
The generator now emits multiline platform sets deterministically.

Native test: `FLUTTER_XCODE_CC="$PWD/tool/macos/compiler_probe.py" flutter test
integration_test/webview_macos_test.dart -d macos`. The Xcode compiler probe had
blocked while writing verbose output through SwiftBuild; the project wrapper captures
that probe and Flutter passes it to xcodebuild as a command-line `CC` setting.
On macOS 26.5 / Xcode 26.6 with Flutter 3.47.2, the Debug integration application
built successfully and real WKWebView loading, back, forward, reload, disposal and
recreation passed. Release artifact validation remains separate from this result.

## Naming contract

Agent Hub task: `normalize-webview-naming`. The user approved project-owned names
with consistent `WebView` spelling. `WebViewEntry`, `WebViewPage`, `WebViewSession`,
`WebViewBackend`, `WebViewEvent` and `WebViewEventKind` are the canonical types.
`WebViewFlutterBackend` (`platforms/webview_flutter_backend.dart`) wraps
webview_flutter for Android/macOS. `WebView2Backend`
(`platforms/webview2_backend.dart`) wraps webview_windows for Windows.
Third-party type names and package imports keep their upstream spelling.

The naming task froze 17 paths against the existing working tree, preserving pending
macOS adaptation and host-build changes. LangGraph scope and rename-equivalence
checks passed; route `/webview`, directory `webview`, dependencies and platforms
were unchanged. Full quality gate passed 6/6 using a temporary candidate index.
Evidence lives in Agent Hub `plans/webview-naming-frozen.json` and
`plans/webview-naming-review.json`. This naming validation does not supersede the
native-runtime limitations recorded above.
