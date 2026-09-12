# Flutter Forge Web Release Candidate — 2026-09-12

## Candidate

- Base commit: `ffeeaba0f60de850be450040de460e92841223c2`
- Scope: Web release preparation on the local `dev` checkout
- Artifact: `release/1.2.6/FlutterForge-1.2.6-web.zip`
- Hosting target: GitHub Release `v1.2.6`, published through Agent Hub

This report records the Web artifact prepared against the existing `v1.2.6`
release line. Other platform artifacts are intentionally reused from that
release and are not rebuilt by this change.

## Local automated evidence

| Check | Result | Evidence |
|---|---|---|
| Web Release compile | PASS | Direct `flutter build web --release --no-web-resources-cdn --pwa-strategy=none --no-pub` completed and produced `build/web` |
| Release resource contract | PASS | `main.dart.js`, controlled media, local CanvasKit configuration and loading shell are present |
| Chrome Web regression | PASS | 20/20 navigation, platform filtering, responsive layout and Web compatibility tests passed |
| Repository quality gate | PASS | 6/6 stages passed: generated docs, format, bare analyze, all tests, test layout and FlutterGuard |
| Workspace tests | PASS | 140 tests passed across 3 workspace members |
| Module test layout | PASS | 22/22 registered modules have tests |
| FlutterGuard release threshold | PASS | 0 HIGH; 14 existing MEDIUM findings reported |

## Local artifact identity

- Directory size: `42M`
- `main.dart.js`: `397545c58677ae9c4122612ad612b70329a167da2b2143172c773208237b1f28`
- `flutter_bootstrap.js`: `60f962741927f3c160b9fcc57fd8507829b031df32f326f666ba96d7eeae3e17`
- `index.html`: `2bcf3d19d2fe5c3dc10f245abfd6d392986cba9d07f7fccfecac2983f76ad103`
- Controlled video: `348ca880240957730680e1bce8e3abff0d6558398899fa7b99285282e3c720a1`
- Release ZIP (`FlutterForge-1.2.6-web.zip`): `4b3bf4a2db73b0bfbf6e1e245b120eee0be747dd769e8a44fa1d483ec2db3d6a`

## Manual compatibility evidence

| Check | Result | Evidence |
|---|---|---|
| Safari wide and 360dp smoke | PASS | Catalog, category navigation, nested navigation and representative popup interaction |
| Full module entry traversal | PASS | 17 available/degraded entries rendered; 5 expected unavailable states rendered; 0 unexpected failures |
| Browser file selection | PASS | Selected filename rendered; cancellation branch covered by Chrome widget test |
| Same-origin video | PASS | Six-second controlled MP4 loaded, played, progressed and paused in Safari Release |
| Chrome manual smoke | PASS | Accepted as completed for this release preparation cycle |
| Edge smoke | PENDING | Required by the browser delivery matrix before deployment |
| Refresh and deep links | PENDING | Direct route load and browser refresh require final hosted-path validation |
| Cold first-frame target | PENDING | Exact four-second target still requires a cold performance trace |

## Release boundaries

- `isolate_basic`, `isolate_task_manager`, `usb_detector`, `gcode_visualizer`
  and `webview` remain visible but unavailable on Web.
- `font_picker` is a degraded learning page; native local-font loading is not a
  Web capability.
- The report does not claim exhaustive execution of every control branch in all
  17 available/degraded modules.
- The local branch is ahead of `origin/dev`; remote CI must pass after the
  candidate is committed and pushed.

## Final deployment checklist

| Gate | Status |
|---|---|
| Commit release-preparation changes and record the final SHA | READY |
| Clean tracked release-candidate worktree | READY |
| Authoritative remote CI on the final SHA | PENDING |
| Edge smoke on the final Release artifact | PENDING |
| Hosted base-path, direct-route and refresh verification | PENDING |
| Cold-start trace against the accepted four-second target | PENDING |
| Select hosting target and execute deployment | Agent Hub `release_hosting` |

The Web candidate is locally buildable and functionally accepted within its
declared capability boundary. Publication is now delegated to the Agent Hub
`release_hosting` graph after the commit is pushed.
