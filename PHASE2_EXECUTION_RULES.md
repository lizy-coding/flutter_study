# Phase 2 Execution Rules (Module Extraction + Routing)

Purpose: keep the migration actions small, repeatable, and documented while
connecting every module to `main_app/lib/main.dart` via a shared route table.

## Rules
1. Only `main_app/lib/main.dart` calls `runApp`. Module code must never call
   `runApp` or create a `MaterialApp`.
2. Each module exposes a single root widget in
   `main_app/lib/<module>/module_entry.dart` named `<ModuleName>Entry`.
3. Module init stays local:
   - Wrap providers or IoC setup inside the entry widget.
   - Use a small shell widget if async init is required.
4. Internal navigation must be registered under the module's GoRoute:
   - Convert named routes to `GoRoute` entries.
   - Strip leading `/` when nesting routes under the module path.
5. Add the module to `main_app/lib/router/app_route_table.dart`:
   - Add to `_modules` with `title`, `path`, `builder`, and optional `routes`.
   - Ensure `path` is unique and kebab-case.
6. Do not delete module-level `main.dart` files until Phase 4 cleanup.
7. Do not move module code out of `main_app/lib/<module>` during Phase 2.

## Template
```dart
class ModuleEntry extends StatelessWidget {
  const ModuleEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: const ModuleHomePage(),
    );
  }
}
```

## Per-module Checklist
1. Identify the module root widget and any init requirements.
2. Create or update `module_entry.dart` to return the root widget.
3. Move any `runApp`, `MaterialApp`, or `WidgetsFlutterBinding` calls out of
   module code and into a local shell if still needed.
4. Register module routes in `app_route_table.dart`.
5. Verify the module opens from the main module list.
