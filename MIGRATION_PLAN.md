# Main App Module Migration Plan

Goal: extract each module's entry widget, register all modules via a single
route table, and fix import issues caused by the lib migration. Only after
navigation works from main_app do we remove redundant module main.dart files.

## Phase 1: Inventory and mapping
- List all module entrypoints (current module main.dart or top-level pages).
- Identify special bootstraps:
  - ProviderScope (riverpod)
  - IoC container initialization
  - Mock server start/stop
  - internal named routes (tree_state, status_manage)
- Define a "module root widget" for each module.

## Phase 2: Extraction and routing
- For each module:
  - Extract or rename the root widget to a reusable widget (no runApp).
  - Move initialization into a shell widget when required.
  - Keep internal navigation working (update to GoRouter push if needed).
- Consolidate all routes into a single static route table file.
- Ensure main_app/lib/app.dart uses a router utility class to load that table.

## Phase 3: Import fixes
- Replace "package:<module>/" imports with relative imports under main_app/lib.
- Resolve any remaining package dependency mismatches in main_app/pubspec.yaml.

## Phase 4: Cleanup
- Remove redundant module main.dart entrypoints and unused MaterialApp shells.
- Keep only the main_app entrypoint for running the app.

## Safety checks (before cleanup)
- main_app launches and module list renders.
- Each module opens and renders from the module list.
- Modules with internal routes still navigate correctly.

## Deliverables
- Updated router table + router utility.
- Clean module entry widgets.
- Fixed imports.
- Removed redundant main.dart files.
