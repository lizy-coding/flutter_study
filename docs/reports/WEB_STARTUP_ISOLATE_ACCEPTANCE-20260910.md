# Web Startup and Isolate Acceptance — 2026-09-10

## Artifact

- Commit under test: `8cea057f11a16a7b4b91a2821ab95e516d2b627b`
- Build: `bash tool/build_web_release.sh`
- Browser: Safari on macOS
- Server: local HTTP server at `127.0.0.1:32174`

## Isolate verdicts

| Check | Verdict | Evidence |
|---|---|---|
| Isolate comparison entry | PASS | Module and nested `with-isolate` route rendered |
| UI response during calculation | PASS | Counter changed from 0 to 1 while calculation was active |
| Isolate calculation progress | FAIL | No first progress event after five seconds |
| Isolate calculation disposal | FAIL | Page does not retain an Isolate handle for cancellation |
| Multi-task progress | FAIL | New task remained at 0% after two seconds |
| Multi-task pause/resume | NOT REACHED | Command port was not received, so pause semantics were not established |

Both Isolate modules must remain visible but unavailable in the Web catalog.
Native behavior is unchanged. A future Web Worker implementation requires a
separate capability task and must not emulate Isolate progress on the UI thread.

## Startup artifact baseline

| Resource | Raw | gzip | brotli |
|---|---:|---:|---:|
| `main.dart.js` | 3,832,224 bytes | 1,128,842 bytes | 861,087 bytes |
| `canvaskit.wasm` | 7,284,602 bytes | 2,919,972 bytes | not measured |
| controlled sample video | 412,455 bytes | not applicable | not applicable |

## Startup verdicts

| Check | Verdict | Evidence |
|---|---|---|
| Static loading shell | PASS | Host renders before Flutter bootstrap and has a ten-second failure state |
| Local CanvasKit | PASS | Release build sets `useLocalCanvasKit=true`; server observed `/canvaskit/` requests |
| Service Worker registration | PASS | Custom bootstrap does not register one and removes legacy registrations |
| Same-origin media | PASS | Server observed `/media/flutter-forge-sample.mp4`; Safari played the six-second asset |
| Exact cold first-frame budget | PENDING | A browser HAR/performance trace has not been exported |
| Route/module deferred loading | DEFERRED | Measure cold release startup before changing the generated route topology |

## Next measurement

Capture Safari and Chrome cold/warm release runs with cache disabled for the
cold case. Record loading-shell, entrypoint, engine initialization, runApp and
first-frame marks. Start route separation only if the cold interactive time
still exceeds the accepted four-second target after compressed same-origin
delivery.
