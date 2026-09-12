#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT/apps/flutter_forge"
OUTPUT="$APP/build/web"

cd "$APP"

# Never allow a failed or interrupted build to be mistaken for a successful
# release by validating files left by an earlier invocation.
rm -rf "$OUTPUT"
flutter build web --release --no-web-resources-cdn --pwa-strategy=none

test -f "$OUTPUT/main.dart.js"
test -f "$OUTPUT/media/flutter-forge-sample.mp4"
grep -q '"useLocalCanvasKit":true' "$OUTPUT/flutter_bootstrap.js"
grep -q 'flutter-forge-loading' "$OUTPUT/index.html"

echo "Web release build verified: local CanvasKit, loading shell, controlled media."
