#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash tool/android_release_local.sh [--all-abis | --aab-only]

By default, builds an Android App Bundle and an arm64-v8a APK.
  --all-abis  Build split APKs for every Flutter-supported Android ABI.
  --aab-only  Build only the Android App Bundle.
EOF
}

apk_mode="arm64"
case "${1:-}" in
  "") ;;
  --all-abis) apk_mode="all" ;;
  --aab-only) apk_mode="none" ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 64
    ;;
esac

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 64
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app_root="$repo_root/apps/flutter_forge"
sdk_root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-$HOME/Library/Android/sdk}}"
output_root="${ANDROID_RELEASE_OUTPUT:-$app_root/build/android-release}"
keystore="$output_root/local-upload-keystore.jks"
store_password="${ANDROID_KEYSTORE_PASSWORD:-local-only-change-me}"
key_alias="${ANDROID_KEY_ALIAS:-local-upload}"
key_password="${ANDROID_KEY_PASSWORD:-$store_password}"

android_studio_jdk="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
if [[ -x "$android_studio_jdk/bin/keytool" ]]; then
  export JAVA_HOME="$android_studio_jdk"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

mkdir -p "$output_root"
if [[ ! -f "$keystore" ]]; then
  keytool -genkeypair -v \
    -keystore "$keystore" \
    -storetype JKS \
    -storepass "$store_password" \
    -keypass "$key_password" \
    -alias "$key_alias" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=Flutter Forge Local,O=Flutter Forge,C=CN"
fi

export ANDROID_KEYSTORE_PATH="$keystore"
export ANDROID_KEYSTORE_PASSWORD="$store_password"
export ANDROID_KEY_ALIAS="$key_alias"
export ANDROID_KEY_PASSWORD="$key_password"

cd "$repo_root"
bash tool/quality_gate.sh

cd "$app_root"
flutter build appbundle --release

bundle="$app_root/build/app/outputs/bundle/release/app-release.aab"
apk_dir="$app_root/build/app/outputs/apk/release"
flutter_apk_dir="$app_root/build/app/outputs/flutter-apk"
apksigner="$sdk_root/build-tools/$(ls -1 "$sdk_root/build-tools" | sort -V | tail -1)/apksigner"
apk_names=(
  app-arm64-v8a-release.apk
  app-armeabi-v7a-release.apk
  app-x86_64-release.apk
)
apks=()

# Remove stale split APKs so the output directory reflects this invocation.
for apk_name in "${apk_names[@]}"; do
  rm -f "$apk_dir/$apk_name" "$flutter_apk_dir/$apk_name"
done

case "$apk_mode" in
  arm64)
    flutter build apk --release --target-platform android-arm64 --split-per-abi
    apks=("$apk_dir/app-arm64-v8a-release.apk")
    ;;
  all)
    flutter build apk --release --split-per-abi
    for apk_name in "${apk_names[@]}"; do
      apks+=("$apk_dir/$apk_name")
    done
    ;;
  none) ;;
esac

[[ -f "$bundle" ]] || { echo "Missing AAB: $bundle" >&2; exit 1; }

if [[ ${#apks[@]} -gt 0 ]]; then
  [[ -x "$apksigner" ]] || { echo "Missing apksigner: $apksigner" >&2; exit 1; }
  for apk in "${apks[@]}"; do
    [[ -f "$apk" ]] || { echo "Missing APK: $apk" >&2; exit 1; }
    "$apksigner" verify --verbose "$apk"
  done
fi
jarsigner -verify -verbose -certs "$bundle" >/dev/null

{
  sha256sum "$bundle"
  if [[ ${#apks[@]} -gt 0 ]]; then
    sha256sum "${apks[@]}"
  fi
} | tee "$output_root/SHA256SUMS"

echo "Android local release validation passed"
echo "AAB: $bundle"
if [[ ${#apks[@]} -gt 0 ]]; then
  printf 'APK: %s\n' "${apks[@]}"
else
  echo "APK: skipped"
fi
