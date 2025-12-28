# Merge Configuration Files

Consolidate duplicate configuration files across your Flutter project for easier maintenance.

## What This Does

Finds and helps merge duplicate configurations:
- `pubspec.yaml` - Dependencies and project metadata
- `analysis_options.yaml` - Dart analyzer and linter rules
- `build.yaml` - Build configuration for code generation
- `firebase.json` - Firebase configuration
- `.gitignore` - Version control ignore patterns
- `.env` files - Environment variables

## Quick Start

```bash
python .claude/skills/project-simplification/scripts/find_duplicate_configs.py
```

## Why Merge Configurations?

**Benefits**:
- Single source of truth for project settings
- Easier to maintain and update
- Consistent behavior across modules
- Reduced confusion for team members
- Simpler CI/CD pipeline configuration

## Configuration Files to Check

### pubspec.yaml
- **Purpose**: Dart/Flutter project dependencies and metadata
- **Best Practice**: Single file at project root only
- **Problem**: Sometimes accidentally created in subdirectories
- **Action**: Consolidate all dependencies into root `pubspec.yaml`

### analysis_options.yaml
- **Purpose**: Dart analyzer and linter rules
- **Best Practice**: Single file at root (can be extended per-package)
- **Merge Strategy**: Union of all rules, resolve conflicts by strictness
- **Consideration**: Stricter rules generally better for code quality

### build.yaml
- **Purpose**: Build configuration for code generation (build_runner)
- **Location**: Usually at root
- **Check**: Ensure no duplicate or conflicting builders
- **Action**: Consolidate build targets and options

### firebase.json / firebase_options.dart
- **Purpose**: Firebase configuration for platforms
- **Location**: Root directory
- **Action**: Consolidate platform-specific settings
- **Note**: Generated files should remain as-is

### .metadata
- **Purpose**: Flutter project metadata (auto-generated)
- **Location**: Root only
- **Action**: Delete any duplicates in subdirectories
- **Important**: Don't manually edit this file

### .gitignore
- **Purpose**: Git ignore patterns
- **Best Practice**: Single file at root
- **Common Issue**: Subdirectory .gitignore files
- **Merge**: Combine all patterns into root .gitignore

### .env / .env.example
- **Purpose**: Environment variables for configuration
- **Best Practice**: Single set at root
- **Security**: Never commit actual .env file
- **Action**: Provide .env.example template only

## Merge Process

### Step 1: Identify All Config Files

```bash
# Find pubspec files
find . -name "pubspec.yaml" -type f

# Find analysis options
find . -name "analysis_options.yaml" -type f

# Find gitignore files
find . -name ".gitignore" -type f

# Find all at once
python scripts/find_duplicate_configs.py
```

### Step 2: Check for Duplicates

Review each found file:

```bash
# Compare two files
diff file1.yaml file2.yaml

# Or use the provided script
python scripts/find_duplicate_configs.py
```

### Step 3: Create Consolidated Configuration

For each config type:

1. **Open all duplicate files side by side**
2. **Identify unique entries** in each file
3. **Resolve conflicts**:
   - Dependencies: Use latest compatible versions
   - Linter rules: Choose stricter settings (or team preference)
   - Ignore patterns: Include all necessary patterns
   - Build options: Merge non-conflicting options
4. **Create merged version** in root directory
5. **Test the merged config** thoroughly

### Step 4: Update References

After merging:

```bash
# Remove duplicate configs
git rm path/to/duplicate/config.yaml

# Find and update any imports/references
grep -r "path/to/duplicate/config" .

# Update imports in Dart files if needed
```

### Step 5: Verify All Modules Work

Ensure everything works with merged config:

```bash
# Get dependencies
flutter pub get

# Run analyzer
flutter analyze

# Run tests
flutter test

# Build to verify
flutter build apk --debug
```

## Merge Examples

### Example 1: Merging analysis_options.yaml

**File 1 (Root)**:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
```

**File 2 (Subdirectory)**:
```yaml
linter:
  rules:
    - prefer_final_locals
    - avoid_print
    - use_key_in_widget_constructors
```

**Merged Result**:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_print
    - prefer_const_constructors
    - prefer_final_locals
    - use_key_in_widget_constructors
```

### Example 2: Merging .gitignore

**Root .gitignore**:
```
# IDE
*.iml
.idea/

# Build
build/
*.apk
```

**Subdirectory .gitignore**:
```
# Logs
*.log

# Environment
.env

# Build
build/
```

**Merged Result** (Root):
```
# IDE
*.iml
.idea/

# Build
build/
*.apk

# Logs
*.log

# Environment
.env
```

### Example 3: Merging pubspec.yaml

**Scenario**: Two pubspec.yaml files with different dependencies

**Root pubspec.yaml**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.0
```

**Module pubspec.yaml**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.0
```

**Merged Result**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.0.0  # Updated to latest compatible
  shared_preferences: ^2.2.0  # Updated to latest compatible
```

## Configuration-Specific Merging

### Merge Specific Config Types

```bash
# Only check pubspec files
CONFIG_TYPE=pubspec python scripts/find_duplicate_configs.py

# Only check analysis options
CONFIG_TYPE=analysis python scripts/find_duplicate_configs.py

# Only check gitignore
CONFIG_TYPE=gitignore python scripts/find_duplicate_configs.py
```

## Common Merge Scenarios

### Scenario 1: Different Dependencies
- **Problem**: Two pubspec.yaml with different packages
- **Solution**: Merge all dependencies, resolve version conflicts
- **Tool**: `flutter pub get` will flag incompatibilities
- **Test**: Run app to ensure all packages work together

### Scenario 2: Conflicting Linter Rules
- **Problem**: Different analysis_options.yaml files
- **Solution**: Choose stricter ruleset or most comprehensive
- **Consideration**: Team consensus on controversial rules
- **Test**: Run `flutter analyze` to see impact

### Scenario 3: Environment Variables
- **Problem**: Multiple .env files in different locations
- **Solution**: Consolidate with clear naming conventions
- **Pattern**: Use prefixes (e.g., `DEV_`, `PROD_`)
- **Security**: Document which vars are sensitive

### Scenario 4: Build Configurations
- **Problem**: Different build.yaml settings
- **Solution**: Merge builders, test all code generation
- **Test**: Run `flutter pub run build_runner build`
- **Verify**: Check generated files are correct

## Validation Checklist

After merging configurations:

- [ ] `flutter pub get` runs successfully
- [ ] `flutter analyze` shows expected warnings only (or none)
- [ ] All code generation works (`build_runner build`)
- [ ] Tests still pass (`flutter test`)
- [ ] App builds correctly (`flutter build`)
- [ ] App runs and functions properly
- [ ] No duplicate config files remain
- [ ] Team members aware of changes

## Troubleshooting

### Dependency Conflicts

```bash
# Clear pub cache
flutter pub cache repair

# Try getting dependencies again
flutter pub get

# Check for version conflicts
flutter pub deps
```

### Linter Errors

```bash
# Run analyze to see all issues
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Adjust analysis_options.yaml if needed
```

### Build Issues

```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter build <platform>
```

### Git Merge Conflicts

```bash
# If you have conflicts after removing files
git status

# Resolve by keeping deletions
git rm path/to/old/config.yaml

# Continue
git commit
```

## Best Practices

1. **Single Source**: One config file per type at root
2. **Version Control**: Commit before and after merging
3. **Testing**: Verify all functionality after merge
4. **Documentation**: Note any config decisions in README
5. **Team Sync**: Ensure team updates their environments
6. **Gradual Migration**: For large projects, merge incrementally
7. **Backup First**: Keep backups of old configs temporarily

## Next Steps

After merging configurations:

1. **Commit changes**:
   ```bash
   git add .
   git commit -m "chore: consolidate configuration files"
   ```

2. **Choose next action**:
   - Continue to [Refactor Large Files](refactor-files.md)
   - Or go to [Complete Workflow](complete-workflow.md)

3. **Validate**: Run `flutter analyze && flutter test`
