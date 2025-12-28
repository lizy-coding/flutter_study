# Troubleshooting

Common issues and solutions during Flutter project simplification.

## Script Issues

### Script Not Found

**Problem**: `python: can't open file 'scripts/analyze_structure.py'`

**Solutions**:
```bash
# Check current directory
pwd

# Should be in project root
cd /path/to/your/project

# Verify script exists
ls .claude/skills/project-simplification/scripts/

# Run with full path
python .claude/skills/project-simplification/scripts/analyze_structure.py
```

### Permission Denied

**Problem**: `Permission denied` when running scripts

**Solutions**:
```bash
# Add execute permissions
chmod +x .claude/skills/project-simplification/scripts/*.py

# Or run with python explicitly
python scripts/script_name.py
```

### Python Dependencies Missing

**Problem**: `ModuleNotFoundError: No module named 'pathspec'`

**Solutions**:
```bash
# Install required packages
pip install pathspec

# Or use pip3
pip3 install pathspec

# Install all dependencies if requirements.txt exists
pip install -r requirements.txt
```

## Analysis Issues

### Large Files List Incomplete

**Problem**: Known large files not in analysis report

**Solutions**:
- Script uses heuristics; manually review files >400 lines
- Adjust threshold: `FILE_SIZE_THRESHOLD=300 python scripts/find_large_files.py`
- Check if files are in excluded directories

### False Positive Duplicates

**Problem**: Files reported as duplicates but aren't

**Solutions**:
- Review files manually
- Check if they serve different purposes
- Consider if "duplication" is intentional (e.g., platform-specific code)
- Update analysis script exclusion rules if needed

### Missing Modules in Analysis

**Problem**: Some modules not detected

**Solutions**:
```bash
# Ensure modules have proper structure
# Each module should have at least one .dart file

# Check directory structure
tree lib/

# Verify no .gitignore excluding modules
cat .gitignore
```

## Build and Dependency Issues

### Build Fails After Changes

**Problem**: `flutter build` fails after refactoring

**Solutions**:
```bash
# Step 1: Clean everything
flutter clean

# Step 2: Get dependencies
flutter pub get

# Step 3: Try building again
flutter build apk --debug

# Step 4: Check for specific errors
flutter analyze

# Step 5: If native issues
cd android && ./gradlew clean
cd ios && pod install
```

### Dependency Conflicts

**Problem**: `version solving failed` or dependency conflicts

**Solutions**:
```bash
# Clear pub cache
flutter pub cache repair

# Remove lock file
rm pubspec.lock

# Get dependencies fresh
flutter pub get

# Check for conflicting versions
flutter pub deps

# Update problematic packages
flutter pub upgrade package_name
```

### Import Errors After Refactoring

**Problem**: `Target of URI doesn't exist`

**Solutions**:
1. Check file was moved correctly:
   ```bash
   find lib/ -name "missing_file.dart"
   ```

2. Update import statement:
   ```dart
   // Old
   import 'old/path/file.dart';

   // New
   import 'new/path/file.dart';
   ```

3. Find all files that need updating:
   ```bash
   grep -r "old/path/file.dart" lib/
   ```

4. Use IDE refactoring tools to update imports automatically

### Circular Dependencies

**Problem**: Circular imports detected

**Solutions**:
1. **Identify the cycle**:
   ```bash
   flutter analyze
   # Look for "Circular dependency" errors
   ```

2. **Break the cycle** using one of these strategies:
   - Extract shared code to a third file
   - Use dependency injection
   - Create interfaces/abstract classes
   - Restructure to unidirectional dependency

3. **Example fix**:
   ```dart
   // Before: A imports B, B imports A

   // After: Extract common code to C
   // A imports C
   // B imports C
   // No circular dependency
   ```

## Testing Issues

### Tests Fail After Refactoring

**Problem**: Tests pass before, fail after refactoring

**Solutions**:
1. **Check imports in test files**:
   ```dart
   // Update to new file locations
   import 'package:your_app/new/path/file.dart';
   ```

2. **Update mocks**:
   ```dart
   // If file structure changed, update mock imports
   ```

3. **Check test data paths**:
   ```dart
   // Verify relative paths still correct
   ```

4. **Run specific test to isolate**:
   ```bash
   flutter test test/specific_test.dart
   ```

### Missing Test Coverage

**Problem**: Refactored code not covered by tests

**Solutions**:
- Write tests for extracted components
- Maintain same test coverage as before
- Run coverage report:
  ```bash
  flutter test --coverage
  genhtml coverage/lcov.info -o coverage/html
  open coverage/html/index.html
  ```

## Configuration Issues

### Merged Config Breaks Build

**Problem**: Build broken after merging configuration files

**Solutions**:
1. **Revert merge temporarily**:
   ```bash
   git checkout HEAD~1 -- pubspec.yaml
   flutter pub get
   flutter build apk --debug
   ```

2. **Identify conflicting setting**:
   - Compare old and new configs
   - Test each section individually

3. **Check platform-specific configs**:
   - Android: `android/app/build.gradle`
   - iOS: `ios/Runner/Info.plist`

### Linter Errors After Merging analysis_options.yaml

**Problem**: Too many linter errors after config merge

**Solutions**:
1. **Gradually enable rules**:
   ```yaml
   # Start with minimal rules
   linter:
     rules:
       - avoid_print

   # Add more over time
   ```

2. **Fix auto-fixable issues**:
   ```bash
   dart fix --apply
   ```

3. **Suppress specific warnings** (sparingly):
   ```dart
   // ignore: rule_name
   problematic_code();

   // ignore_for_file: rule_name
   ```

4. **Disable problematic rules temporarily**:
   ```yaml
   linter:
     rules:
       # - controversial_rule  # Commented out
       - safe_rule
   ```

## Documentation Issues

### Broken Links in Generated READMEs

**Problem**: Links don't work in generated documentation

**Solutions**:
1. **Use relative paths**:
   ```markdown
   # Good
   [Module](../other_module/)

   # Bad (absolute)
   [Module](/path/from/root/module/)
   ```

2. **Verify file structure**:
   ```bash
   # Check linked file exists
   ls lib/module_name/README.md
   ```

3. **Regenerate documentation**:
   ```bash
   python scripts/generate_module_readmes.py
   python scripts/generate_root_readme.py
   ```

### Empty or Generic Descriptions

**Problem**: Generated READMEs lack meaningful content

**Solutions**:
1. **Add doc comments** to module files:
   ```dart
   /// # My Module
   ///
   /// Detailed description here...
   library my_module;
   ```

2. **Edit module_descriptions.json** manually

3. **Enhance generated files** after creation

## Git and Version Control Issues

### Merge Conflicts

**Problem**: Git merge conflicts after simplification

**Solutions**:
```bash
# Check conflict status
git status

# For deleted files
git rm path/to/deleted/file

# For modified files
git checkout --ours path/to/file   # Keep your version
git checkout --theirs path/to/file # Keep their version
# Or manually resolve in editor

# Continue merge
git add .
git commit
```

### Lost Changes

**Problem**: Changes disappeared after refactoring

**Solutions**:
```bash
# Check git reflog
git reflog

# Find your commit
git show commit_hash

# Restore if needed
git checkout commit_hash -- path/to/file

# Or cherry-pick
git cherry-pick commit_hash
```

## Performance Issues

### Analysis Takes Too Long

**Problem**: Structure analysis script runs forever

**Solutions**:
```bash
# Analyze specific module only
MODULE=specific_module python scripts/analyze_structure.py

# Exclude large directories
# Edit script to skip node_modules, build/, etc.

# Increase timeout if needed
```

### Large README Generation Slow

**Problem**: README generation takes very long

**Solutions**:
```bash
# Generate for specific modules
MODULES="module1,module2" python scripts/generate_module_readmes.py

# Skip large modules temporarily
EXCLUDE="large_module" python scripts/generate_module_readmes.py

# Run in parallel (if script supports)
```

## Platform-Specific Issues

### iOS Build Issues

**Problem**: iOS build fails after simplification

**Solutions**:
```bash
# Update CocoaPods
cd ios
pod install
pod update

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean iOS build
flutter clean
cd ios
xcodebuild clean
```

### Android Build Issues

**Problem**: Android build fails

**Solutions**:
```bash
# Clean gradle
cd android
./gradlew clean

# Invalidate caches
./gradlew --stop
rm -rf .gradle

# Update gradle wrapper
./gradlew wrapper --gradle-version=7.5

# Back to root
cd ..
flutter clean
flutter pub get
```

### Web Build Issues

**Problem**: Web build fails

**Solutions**:
```bash
# Clear web build cache
flutter clean

# Rebuild
flutter build web

# Check for web-specific dependencies
# Some packages don't support web
```

## Common Error Messages

### "The method 'X' isn't defined"

**Cause**: File moved, import not updated

**Fix**:
```bash
# Find where method is defined
grep -r "methodName" lib/

# Update import in file with error
```

### "Can't infer type"

**Cause**: Moved code broke type inference

**Fix**:
```dart
// Add explicit types
final String value = getValue();
final List<User> users = fetchUsers();
```

### "context.read/watch not found"

**Cause**: Provider import missing after refactoring

**Fix**:
```dart
import 'package:provider/provider.dart';
```

## Getting Help

If issues persist:

1. **Check project-specific documentation**
2. **Review git history** for what changed
3. **Ask team members** familiar with the code
4. **Revert and try again** incrementally
5. **File an issue** if it's a script bug

### Reporting Issues

When reporting problems, include:
- Exact error message
- Steps to reproduce
- Flutter version: `flutter --version`
- Script command used
- Relevant file paths

## Prevention

**Avoid these issues**:
- ✓ Commit before each phase
- ✓ Test after each change
- ✓ Review diffs carefully
- ✓ Keep backups
- ✓ Work incrementally
- ✓ Communicate with team
- ✓ Read error messages carefully

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- [Best Practices Guide](best-practices.md)
