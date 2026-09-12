# Flutter Forge Web Compatibility Report — updated 2026-09-11

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
| Module browser traversal | PASS | Safari Release rendered all 17 available/degraded module entries and all 5 expected unavailable states without unexpected route or blank-page failures |
| Exhaustive control interaction | PARTIAL | Representative interactions passed, including nested navigation, compact dialogs, file selection and video playback; every control branch is not claimed |
| File picker interaction | PASS | Safari browser selection renders the selected filename; Web uses unrestricted single-file selection and the widget cancellation branch passes in Chrome |
| Online video playback | PASS | Safari Release played the same-origin six-second MP4; duration, progress and play/pause were observed |
| Startup usability | PASS | Safari Release reached the catalog with the static loading shell, local CanvasKit and same-origin resources; exact cold-frame timing remains separately tracked |
| Embedded WebView | NOT SUPPORTED | Browser host is not treated as a native WebView backend |

## Capability boundary

- Platform-neutral modules remain available on Web when they compile through
  their existing Flutter/Dart implementation.
- `dio-interceptor`, `file-picker`, and `online-video-player` are available in
  the Web catalog through their Web-specific capability implementations.
- `webview`, `gcode-visualizer`, and `usb-detector` remain unavailable in the
  Web catalog.
- `isolate-basic` and `isolate-stream` remain unavailable in the Web catalog;
  Safari validation showed unreliable progress and lifecycle control for
  `Isolate.spawn`.
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
- File picker: Safari opened the browser chooser and the selected single file
  rendered its filename at wide and 360dp viewports; Web does not expose the
  native extension-filter controls or blob path in the learning result.
- File picker cancellation: the widget cancellation branch passed in Chrome;
  manual empty-dialog cancellation is not a release blocker for the single-file
  filename use case.
- Online video: Safari Release loaded `/media/flutter-forge-sample.mp4`, read a
  six-second duration, started from the user gesture, advanced playback, and
  paused successfully.
- Startup: the Release artifact showed the loading shell before Flutter, used
  local `/canvaskit/` resources, removed legacy service-worker control, and
  reached the usable catalog. The exact cold first-frame budget remains in
  `WEB_STARTUP_ISOLATE_ACCEPTANCE-20260910.md` as PENDING measurement work.
- Browser console: a Noto font fallback warning remains; the only observed
  Engine view assertion occurred while hot-restarting the debug server and was
  not reproduced during normal navigation.
- Full module entry traversal is recorded in
  `WEB_MODULE_TRAVERSAL-20260911.md`. Remaining non-blocking evidence scope is
  every control branch and automated screenshot coverage. Refresh/deep-link,
  Edge smoke and exact cold-start timing remain release-candidate checks.

## Commands

```text
flutter analyze
flutter test --platform chrome test/shared/navigation_policy_test.dart test/shared/module_catalog_utils_test.dart test/shared/responsive_navigation_layout_test.dart test/shared/web_compatibility_test.dart
bash tool/test_all.sh
flutter build web --release
bash tool/build_web_release.sh
bash tool/quality_gate.sh
```
