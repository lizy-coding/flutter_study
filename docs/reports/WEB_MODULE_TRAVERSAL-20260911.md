# Web Release 全模块遍历 — 2026-09-11

## Environment

- Artifact: current `bash tool/build_web_release.sh` output
- Browser: Safari on macOS
- Server: local HTTP server at `127.0.0.1:32174`
- Scope: catalog entry rendering, expected unavailable states, module page first render

## Traversal summary

| Result | Count |
|---|---:|
| Available/degraded modules rendered | 17 |
| Expected Web-unavailable states rendered | 5 |
| Unexpected module failures | 0 |

## Available or degraded modules

| Module | Verdict | Observation |
|---|---|---|
| tree_state | PASS | Page rendered with nested lifecycle buttons |
| microtask | PASS | Event-loop learning page and nested examples rendered |
| debounce_throttle | PASS | Debounce/throttle controls rendered |
| stream_subscription | PASS | Stream learning page rendered |
| status_management | PASS | Provider/Riverpod comparison page rendered |
| flutter_ioc | PASS | IoC page rendered with name input |
| local_persistence | PASS | Counter, persistence controls and storage actions rendered |
| adsorption_line | PASS | Canvas controls, color controls and width slider rendered |
| download_animation | PASS | Three animation implementation choices rendered |
| font_picker | DEGRADED PASS | Web fallback learning page rendered; local font loading remains unavailable |
| popup_widgets | PASS | Dialog, sheet, menu and overlay controls rendered |
| popup_list_interaction | PASS | Nested popup/list learning page rendered |
| scroll_table | PASS | Two-dimensional employee table rendered |
| overlay_follow_compare | PASS | Follower and manual overlay comparison rendered |
| dio_interceptor | PASS | Existing browser acceptance retained; Web adapter path is available |
| file_picker | PASS | Existing browser acceptance retained; single-file filename flow is available |
| online_video_player | PASS | Existing Safari same-origin playback acceptance retained |

## Expected unavailable states

| Module | Verdict | Reason shown/contract |
|---|---|---|
| isolate_basic | PASS unavailable | Web `Isolate.spawn` progress lifecycle failed validation |
| isolate_task_manager | PASS unavailable | Web task progress/command port failed validation |
| usb_detector | PASS unavailable | Android USB-only capability |
| gcode_visualizer | PASS unavailable | macOS GPU/Impeller-only external contract |
| webview | PASS unavailable | Native WebView backends are not browser Web support |

## Issues observed

- No unexpected route failure, blank page, or browser error was observed during
  the traversal.
- The exact cold first-frame timing remains a performance measurement item;
  startup usability and local resource loading passed the current manual bar.
- This report records module traversal, not every module's exhaustive control
  interaction or deep-link/refresh behavior.
