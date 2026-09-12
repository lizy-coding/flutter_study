{
  "schema": "vibecoding.harness.ai_analysis.v2",
  "mode": "package_contract",
  "node": {
    "id": "flutter_forge.workspace.desktop_multi_window",
    "kind": "flutter_plugin_package",
    "package": "desktop_multi_window",
    "path": "packages/desktop_multi_window",
    "status": "active"
  },
  "package_type": "flutter_plugin_package",
  "workspace": {
    "member": true,
    "resolution": "workspace",
    "resolution_status": "active",
    "resolution_blocker": "none"
  },
  "entrypoints": [
    "lib/desktop_multi_window.dart"
  ],
  "owns": [
    "desktop_window_lifecycle",
    "multi_window_host_bridge"
  ],
  "depends": [
    "flutter_sdk"
  ],
  "children": [],
  "contracts": {
    "no_natural_language": true,
    "doc_consumer": "coding_agent",
    "doc_mode": "machine_contract"
  },
  "validation": [
    "flutter pub get",
    "flutter analyze",
    "flutter test"
  ],
  "test_status": "configured"
}
