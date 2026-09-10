# Flutter Forge Web Compatibility Report — 2026-09-08

## Scope

This baseline makes the current Flutter Forge feature set safe to compile and
open on Web. It does not add modules or promote unverified native capabilities
to Web support.

## Result

| Check | Status | Evidence |
|---|---|---|
| Web host | PASS | `apps/flutter_forge/web` uses the existing app bootstrap |
| Release build | PASS | `flutter build web --release` exited 0 |
| Web navigation | PASS | Chrome test verifies Web always uses in-app navigation |
| Platform filtering | PASS | Chrome test verifies browser OS does not unlock native modules |
| Safe compatibility pages | PASS | Chrome widget tests cover connected Web modules and native-only fallback entries |
| Native regression suite | PASS | `bash tool/test_all.sh` passed 3/3 workspace members |
| Repository quality gate | PASS | `bash tool/quality_gate.sh` passed 6/6 stages |
| Manual browser traversal | PARTIAL | Wide and 360dp browser smoke covered the catalog, category navigation, a nested lifecycle interaction, platform unavailable states and AlertDialog; exhaustive per-module traversal remains pending |
| File picker interaction | PARTIAL | Browser selection passed for `.gcode` and `.txt`, including filter and result rendering; native dialog cancellation remains pending |
| Online video playback | PENDING | Web backend is connected; manual playback remains outside this file-picker validation pass |
| Embedded WebView | NOT SUPPORTED | Browser host is not treated as a native WebView backend |

## Capability boundary

- Platform-neutral modules remain available on Web when they compile through
  their existing Flutter/Dart implementation.
- `dio-interceptor`, `file-picker`, and `online-video-player` are available in
  the Web catalog through their Web-specific capability implementations.
- `webview`, `gcode-visualizer`, and `usb-detector` remain unavailable in the
  Web catalog.
- Font picker uses its existing learning entry with a Web compatibility page;
  native local-font loading is not claimed on Web.
- Web never initializes `desktop_multi_window` and never inherits macOS or
  Windows module availability from the browser operating system.

## Manual browser smoke

- Wide viewport: home catalog rendering, basic module navigation, nested State
  lifecycle page, `setState +1`, back navigation, async category, and platform
  category passed.
- 360dp viewport: compact catalog, platform unavailable cards, popup module,
  and AlertDialog open/dismiss passed without visible overflow.
- File picker: G-code selection accepted `.gcode`; text mode exposed
  `.txt,.md,.log`; both selections rendered the filename, browser `blob:` URL,
  and browser-managed size state at wide and 360dp viewports.
- File picker cancellation: the widget cancellation branch passed in Chrome;
  manual browser-dialog cancellation is still pending because the automation
  file chooser cannot complete with an empty file list.
- Browser console: a Noto font fallback warning remains; the only observed
  Engine view assertion occurred while hot-restarting the debug server and was
  not reproduced during normal navigation.
- Remaining scope: every module's complete interactive surface, browser
  refresh/deep-link behavior, release-build browser traversal, and automated
  screenshot evidence.

## Commands

```text
flutter analyze
flutter test --platform chrome test/shared/navigation_policy_test.dart test/shared/module_catalog_utils_test.dart test/shared/responsive_navigation_layout_test.dart test/shared/web_compatibility_test.dart
bash tool/test_all.sh
flutter build web --release
bash tool/quality_gate.sh
```
