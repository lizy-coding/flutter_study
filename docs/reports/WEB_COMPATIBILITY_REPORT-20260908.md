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
| Safe compatibility pages | PASS | Chrome widget test renders Web-safe file, video, font and G-code entries |
| Native regression suite | PASS | `bash tool/test_all.sh` passed 3/3 workspace members |
| Repository quality gate | PASS | `bash tool/quality_gate.sh` passed 6/6 stages |
| Manual browser traversal | PENDING | No manual visual acceptance or screenshot was performed |
| File picker interaction | PENDING | No browser file dialog backend is claimed |
| Online video playback | PENDING | No browser media playback backend is claimed |
| Embedded WebView | NOT SUPPORTED | Browser host is not treated as a native WebView backend |

## Capability boundary

- Platform-neutral modules remain available on Web when they compile through
  their existing Flutter/Dart implementation.
- `file-picker`, `online-video-player`, `webview`, `gcode-visualizer`, and
  `usb-detector` remain unavailable in the Web catalog.
- Font picker uses its existing learning entry with a Web compatibility page;
  native local-font loading is not claimed on Web.
- Web never initializes `desktop_multi_window` and never inherits macOS or
  Windows module availability from the browser operating system.

## Commands

```text
flutter analyze
flutter test --platform chrome test/shared/navigation_policy_test.dart test/shared/module_catalog_utils_test.dart test/shared/responsive_navigation_layout_test.dart test/shared/web_compatibility_test.dart
bash tool/test_all.sh
flutter build web --release
bash tool/quality_gate.sh
```
