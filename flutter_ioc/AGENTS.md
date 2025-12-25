# Repository Guidelines

## Project Structure & Module Organization
- `lib/main.dart` bootstraps the app and registers `ChangeNotifierProvider` for IoC.
- `lib/model/counter_model.dart` contains counter state, mutation methods, and serialization helpers.
- Platform scaffolding sits in `android/` and `windows/`; change only when targeting those builds.
- `pubspec.yaml` declares SDK constraints and dependencies (`provider`, `flutter_lints`); keep edits intentional and run `flutter pub get`.

## Build, Test, and Development Commands
- `flutter pub get` installs or updates dependencies.
- `flutter run -d windows` (or your device id) launches the sample counter for manual checks.
- `flutter analyze` runs static analysis with the default lint set.
- `dart format lib` keeps the 2-space Dart style; trailing commas help stable diffs.
- `flutter test` executes future unit/widget tests in `test/`.
- `flutter build apk --release` generates a production Android package after checks pass.

## Coding Style & Naming Conventions
- Standard Dart style: 2-space indent, snake_case files, PascalCase types, and `const` widgets when possible.
- Keep widget build methods pure; move stateful logic into models/providers to preserve IoC separation.
- Avoid global mutable state; pass defaults and config through constructors or providers.
- Keep serialization and business defaults in models; keep UI strings in widgets.

## Testing Guidelines
- Mirror `lib/` paths under `test/` (e.g., `test/model/counter_model_test.dart`) and prefer small, focused cases.
- Cover `increment`, `setName`, and map/JSON helpers with unit tests; add widget tests with `ChangeNotifierProvider` to mirror DI.
- Name tests by behavior (`should increment count on tap`) and follow arrange-act-assert.
- Run `flutter test` and `flutter analyze` before pushing.

## Commit & Pull Request Guidelines
- History favors short prefixed commits (`feat:`, `style:`, `chore:`) often with concise Chinese summaries; match that format and keep scope tight.
- One concern per commit; reference issues inline when relevant (`feat: add counter name input #123`).
- PRs need: what/why, how to test (commands run), and screenshots/GIFs for UI changes.
- Note dependency or platform config changes and ensure format/analyze/test are clean before review.

## IoC & Dependency Injection Notes
- Instantiate notifiers in `main.dart`, expose them via `Provider.of`/`context.watch`, and keep models UI-agnostic.
- Maintain serializable models (`toMap`, `toJson`) so persistence or networking can be added without rewriting the widget layer.
