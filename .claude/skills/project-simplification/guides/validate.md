# Validate Project

Run comprehensive quality checks to ensure all changes work correctly and maintain code quality.

## What This Does

Performs complete validation including:
- **Code Quality**: Run `flutter analyze` for static analysis
- **Build Integrity**: Verify `flutter pub get` and imports
- **Test Coverage**: Run existing tests
- **File Organization**: Verify module structure
- **Dependency Health**: Check for unused dependencies
- **Documentation**: Verify links and references

## Quick Start

```bash
python scripts/validate_project.py
```

This runs all validation checks in sequence.

## Individual Validation Steps

### 1. Code Quality - Static Analysis

```bash
flutter analyze
```

**What it checks**:
- Dart analyzer warnings and errors
- Linter rule violations
- Type safety issues
- Deprecated API usage
- Potential bugs

**Expected**: No errors, minimal warnings

### 2. Build Integrity

```bash
# Get dependencies
flutter pub get

# Verify imports
flutter analyze --no-fatal-infos
```

**What it checks**:
- All dependencies resolve correctly
- No missing packages
- All imports are valid
- No circular dependencies

**Expected**: Clean dependency resolution

### 3. Test Suite

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific tests
flutter test test/widget_test.dart
```

**What it checks**:
- All unit tests pass
- All widget tests pass
- All integration tests pass
- Test coverage meets standards

**Expected**: All tests pass

### 4. Build Verification

```bash
# Build for debug
flutter build apk --debug

# Build for release
flutter build apk --release

# Build for other platforms
flutter build ios
flutter build web
```

**What it checks**:
- Project builds successfully
- No build-time errors
- Resources are accessible
- Native code compiles

**Expected**: Successful builds

### 5. File Organization

Manually verify:
- [ ] Module structure is logical
- [ ] No orphaned files
- [ ] Naming conventions followed
- [ ] Directory depth reasonable (<4 levels)
- [ ] Related files grouped together

### 6. Dependency Health

```bash
# Check dependencies
flutter pub deps

# Check for outdated packages
flutter pub outdated

# Find unused dependencies
dart pub global activate dependency_validator
dependency_validator
```

**What it checks**:
- All dependencies are used
- No conflicting versions
- Dependencies are up-to-date (if desired)

**Expected**: All dependencies are necessary

### 7. Documentation Validation

```bash
# Check for broken markdown links
grep -r "\[.*\](.*))" --include="*.md" .

# Verify README files exist
ls lib/*/README.md

# Check documentation coverage
dartdoc --validate-links
```

**What it checks**:
- All links are valid
- README files present
- Documentation is comprehensive

**Expected**: No broken links, complete docs

## Complete Validation Checklist

Run through this checklist after simplification:

### Code Quality
- [ ] `flutter analyze` passes with no errors
- [ ] All linter warnings addressed or suppressed intentionally
- [ ] No deprecated API usage (or documented)
- [ ] Type safety maintained

### Build & Dependencies
- [ ] `flutter pub get` runs successfully
- [ ] All imports resolve correctly
- [ ] App builds for all target platforms
- [ ] No unused dependencies

### Tests
- [ ] All unit tests pass
- [ ] All widget tests pass
- [ ] All integration tests pass
- [ ] Test coverage meets team standards (e.g., >80%)
- [ ] New code has tests

### Functionality
- [ ] App launches successfully
- [ ] All features work as expected
- [ ] No runtime errors
- [ ] Performance acceptable
- [ ] UI renders correctly

### Structure & Organization
- [ ] Module structure is clear and logical
- [ ] File names follow conventions
- [ ] No files over 500 lines
- [ ] Directory depth reasonable
- [ ] No duplicate code

### Documentation
- [ ] README files up-to-date
- [ ] All modules documented
- [ ] Code comments where needed
- [ ] API documentation generated
- [ ] No broken links

### Version Control
- [ ] All changes committed
- [ ] Commit messages are descriptive
- [ ] No merge conflicts
- [ ] Branch is up-to-date with main

## Automated Validation Script

The `validate_project.py` script automates most checks:

```python
# Example output
Running Flutter Project Validation...

✓ Code Analysis: PASSED
✓ Dependency Check: PASSED
✓ Build Verification: PASSED
✓ Test Suite: PASSED (127/127 tests)
✓ Documentation: PASSED
✓ File Organization: PASSED

Overall: ALL CHECKS PASSED
```

## Handling Validation Failures

### Code Analysis Failures

**Problem**: `flutter analyze` shows errors

**Solutions**:
```bash
# Fix auto-fixable issues
dart fix --apply

# Check specific file
flutter analyze lib/path/to/file.dart

# Suppress specific warnings (use sparingly)
// ignore: rule_name
```

### Dependency Failures

**Problem**: Dependency conflicts or missing packages

**Solutions**:
```bash
# Clear cache
flutter pub cache repair

# Remove pub get lock
rm pubspec.lock
flutter pub get

# Update dependencies
flutter pub upgrade
```

### Test Failures

**Problem**: Tests failing after refactoring

**Solutions**:
1. Review test output carefully
2. Check if imports need updating
3. Verify test data/mocks are correct
4. Update tests if API changed intentionally
5. Run single test to isolate issue:
   ```bash
   flutter test test/specific_test.dart
   ```

### Build Failures

**Problem**: Build fails with errors

**Solutions**:
```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Try building again
flutter build apk --debug

# Check native code
cd android && ./gradlew clean
cd ios && pod install
```

## Performance Validation

After major refactoring, verify performance:

### Check App Performance

```bash
# Run with performance overlay
flutter run --profile

# Measure specific performance
flutter run --trace-startup
```

### Profile Memory Usage

```dart
# Add to app
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  debugPrintGlobalMemoryAllocations();
}
```

### Check Build Size

```bash
# Analyze bundle size
flutter build apk --analyze-size

# For web
flutter build web --analyze-size
```

## Continuous Validation

Set up pre-commit hooks to validate automatically:

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "Running pre-commit validation..."

# Run analyzer
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ flutter analyze failed"
  exit 1
fi

# Run tests
flutter test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed"
  exit 1
fi

echo "✅ All validation passed"
exit 0
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## CI/CD Integration

Add validation to CI pipeline:

```yaml
# .github/workflows/validate.yml
name: Validate

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'

      - name: Get dependencies
        run: flutter pub get

      - name: Analyze
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Build
        run: flutter build apk --debug
```

## Validation Best Practices

### 1. Validate Frequently
- After each refactoring step
- Before committing
- Before pushing
- Before creating PR

### 2. Automate Validation
- Use pre-commit hooks
- Set up CI/CD pipeline
- Run validation script regularly

### 3. Don't Skip Tests
- Tests catch regressions
- Ensure refactoring didn't break functionality
- Maintain test coverage

### 4. Check All Platforms
- If multi-platform, test all targets
- Platform-specific issues exist
- Build for all supported platforms

### 5. Performance Matters
- Profile after major changes
- Check memory usage
- Verify startup time
- Monitor build size

## Next Steps

After validation:

1. **If all checks pass**:
   ```bash
   git add .
   git commit -m "chore: project simplification complete"
   ```

2. **If checks fail**:
   - Fix issues identified
   - Re-run validation
   - Don't proceed until clean

3. **Final steps**:
   - Update CHANGELOG
   - Update version if appropriate
   - Create PR for team review
   - Merge to main branch

4. **Celebrate**: Project simplification complete! 🎉

## Additional Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Dart Analysis Options](https://dart.dev/guides/language/analysis-options)
- [Best Practices](best-practices.md)
- [Troubleshooting](troubleshooting.md)
