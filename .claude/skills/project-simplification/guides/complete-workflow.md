# Complete Workflow Guide

Step-by-step guide for full Flutter project simplification from start to finish.

## Overview

This guide walks through the complete simplification process, combining all individual tasks into a cohesive workflow. Use this when you want to perform a comprehensive project cleanup.

**Total Time**: 2-4 hours (depending on project size)

**Prerequisites**:
- Project backed up and committed
- Flutter environment set up
- Python installed for scripts

## Workflow Phases

The complete workflow consists of 6 sequential phases:

1. **Analyze** - Understand project structure and issues
2. **Clean** - Remove redundant documentation
3. **Merge** - Consolidate configuration files
4. **Refactor** - Break up large files
5. **Document** - Generate comprehensive READMEs
6. **Validate** - Ensure quality and correctness

## Phase 1: Analyze Project Structure (20 min)

### Step 1.1: Prepare

```bash
# Commit current state
git add .
git commit -m "checkpoint: before project simplification"
git push

# Verify clean working directory
git status
```

### Step 1.2: Run Analysis

```bash
python .claude/skills/project-simplification/scripts/analyze_structure.py
```

### Step 1.3: Review Results

```bash
# Review analysis report
cat analysis_report.json

# Or if formatted output:
python -m json.tool analysis_report.json
```

### Step 1.4: Identify Priorities

Review and note:
- [ ] Modules with >20 files
- [ ] Files over 500 lines
- [ ] Duplicate classes/files
- [ ] Deep directory nesting (>4 levels)
- [ ] Circular dependencies

**Decision Point**: Based on analysis, decide which phases are most needed for your project.

**→ [Detailed guide](analyze-structure.md)**

---

## Phase 2: Clean Redundant Documentation (15 min)

### Step 2.1: Find Redundant Docs

```bash
python .claude/skills/project-simplification/scripts/find_redundant_docs.py
```

### Step 2.2: Manual Review

```bash
# List all markdown files
find . -name "*.md" -type f

# Search for READMEs
find . -name "README.md"

# Search for CHANGELOGs
find . -name "CHANGELOG*"
```

### Step 2.3: Merge and Delete

For each redundant doc:
1. Read and extract unique content
2. Merge into primary documentation
3. Check for references:
   ```bash
   grep -r "redundant_doc.md" .
   ```
4. Delete file:
   ```bash
   git rm path/to/redundant_doc.md
   ```

### Step 2.4: Commit

```bash
git add .
git commit -m "docs: clean up redundant documentation"
```

**→ [Detailed guide](clean-docs.md)**

---

## Phase 3: Merge Configuration Files (20 min)

### Step 3.1: Find Duplicate Configs

```bash
python .claude/skills/project-simplification/scripts/find_duplicate_configs.py
```

### Step 3.2: Manual Check

```bash
# Find all pubspec files
find . -name "pubspec.yaml"

# Find all analysis_options
find . -name "analysis_options.yaml"

# Find all .gitignore files
find . -name ".gitignore"
```

### Step 3.3: Merge Configurations

For each config type:

1. **Compare files**:
   ```bash
   diff file1.yaml file2.yaml
   ```

2. **Merge content**:
   - Combine all unique entries
   - Resolve conflicts (choose stricter/latest)
   - Update root config file

3. **Delete duplicates**:
   ```bash
   git rm path/to/duplicate/config.yaml
   ```

### Step 3.4: Test

```bash
# Get dependencies
flutter pub get

# Run analysis
flutter analyze

# Verify build
flutter build apk --debug
```

### Step 3.5: Commit

```bash
git add .
git commit -m "chore: consolidate configuration files"
```

**→ [Detailed guide](merge-configs.md)**

---

## Phase 4: Refactor Large Files (45-90 min)

This is often the most time-consuming phase.

### Step 4.1: Identify Large Files

```bash
python .claude/skills/project-simplification/scripts/find_large_files.py
```

Or manually:
```bash
find lib/ -name "*.dart" -exec wc -l {} + | sort -rn | head -20
```

### Step 4.2: Prioritize

Rank files by:
- Size (largest first)
- Complexity (most complex first)
- Change frequency (most changed first)
- Team pain points (most complained about)

### Step 4.3: Refactor Each File

For each large file:

1. **Commit checkpoint**:
   ```bash
   git add .
   git commit -m "checkpoint: before refactoring [filename]"
   ```

2. **Analyze responsibilities**:
   - What does this file do?
   - What can be extracted?
   - How are components related?

3. **Plan extraction**:
   - Models to extract
   - Services to extract
   - Widgets to extract
   - Utilities to extract

4. **Extract components** (one at a time):
   - Create new file
   - Move code
   - Update imports in new file
   - Update imports in old file
   - Test

5. **Verify after each extraction**:
   ```bash
   flutter analyze
   flutter test
   flutter run
   ```

6. **Commit after each successful extraction**:
   ```bash
   git add .
   git commit -m "refactor([module]): extract [component] from [file]"
   ```

### Step 4.4: Final Verification

```bash
# Run full analysis
flutter analyze

# Run all tests
flutter test

# Build app
flutter build apk --debug

# Manual testing
flutter run
```

### Step 4.5: Commit Phase Complete

```bash
git add .
git commit -m "refactor: complete large file refactoring"
```

**→ [Detailed guide](refactor-files.md)**

---

## Phase 5: Generate Documentation (20 min)

### Step 5.1: Generate Module Descriptions

```bash
python .claude/skills/project-simplification/scripts/generate_module_descriptions.py
```

**Output**: `module_descriptions.json`

### Step 5.2: Generate Module READMEs

```bash
python .claude/skills/project-simplification/scripts/generate_module_readmes.py
```

**Output**: `lib/<module>/README.md` for each module

### Step 5.3: Generate Root README

```bash
python .claude/skills/project-simplification/scripts/generate_root_readme.py
```

**Output**: `README.md` at project root

### Step 5.4: Review and Enhance

```bash
# List generated READMEs
ls lib/*/README.md

# Review root README
cat README.md

# Check main README
ls -la README.md
```

Manually enhance:
- Add screenshots
- Add detailed examples
- Fix any inaccuracies
- Add architecture diagrams

### Step 5.5: Verify Links

```bash
# Check for broken links
grep -r "\[.*\](.*))" README.md lib/*/README.md
```

### Step 5.6: Commit

```bash
git add README.md lib/*/README.md module_descriptions.json
git commit -m "docs: generate comprehensive project documentation"
```

**→ [Detailed guide](generate-docs.md)**

---

## Phase 6: Validate and Test (25 min)

Final comprehensive validation.

### Step 6.1: Code Quality

```bash
# Run static analysis
flutter analyze

# Should show no errors, minimal warnings
```

**Fix any issues found before proceeding.**

### Step 6.2: Build Integrity

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Verify all imports resolve
flutter analyze --no-fatal-infos
```

### Step 6.3: Test Suite

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# All tests should pass
```

### Step 6.4: Build Verification

```bash
# Build for target platforms
flutter build apk --debug
flutter build ios --debug  # If applicable
flutter build web           # If applicable

# All builds should succeed
```

### Step 6.5: Manual Testing

```bash
# Run app
flutter run

# Test critical features:
# - App launches
# - Navigation works
# - Data loads
# - Features function
# - No crashes
```

### Step 6.6: Performance Check

```bash
# Run with performance overlay
flutter run --profile

# Check:
# - Startup time reasonable
# - UI responsive
# - No janky animations
# - Memory usage stable
```

### Step 6.7: Final Commit

```bash
git add .
git commit -m "chore: complete project simplification and validation"
git push
```

**→ [Detailed guide](validate.md)**

---

## Post-Completion Checklist

After completing all phases:

### Code Quality
- [ ] `flutter analyze` passes
- [ ] All tests pass
- [ ] No deprecated API usage
- [ ] Code follows style guide

### Structure
- [ ] No files over 500 lines
- [ ] Modules organized logically
- [ ] Naming conventions followed
- [ ] No duplicate code

### Configuration
- [ ] Single pubspec.yaml at root
- [ ] Single analysis_options.yaml
- [ ] Single .gitignore
- [ ] No duplicate configs

### Documentation
- [ ] Root README comprehensive
- [ ] Each module has README
- [ ] All links work
- [ ] Code comments where needed

### Build & Deploy
- [ ] App builds successfully
- [ ] All platforms tested
- [ ] No runtime errors
- [ ] Performance acceptable

### Team
- [ ] Changes communicated
- [ ] Team reviewed changes
- [ ] Onboarding docs updated
- [ ] Knowledge shared

---

## One-Command Execution

For the brave, run all phases sequentially:

```bash
# Full workflow (use with caution!)
python .claude/skills/project-simplification/scripts/analyze_structure.py && \
python .claude/skills/project-simplification/scripts/find_redundant_docs.py && \
python .claude/skills/project-simplification/scripts/find_duplicate_configs.py && \
python .claude/skills/project-simplification/scripts/find_large_files.py && \
python .claude/skills/project-simplification/scripts/generate_module_descriptions.py && \
python .claude/skills/project-simplification/scripts/generate_module_readmes.py && \
python .claude/skills/project-simplification/scripts/generate_root_readme.py && \
python .claude/skills/project-simplification/scripts/validate_project.py

echo "Workflow complete! Review changes and commit."
```

**Warning**: This runs analysis and generation only. Actual refactoring must be done manually.

---

## Customizing the Workflow

### Skip Phases

If certain phases aren't needed:

```bash
# Example: Skip documentation cleanup, go straight to refactoring
# Phase 1: Analyze
python scripts/analyze_structure.py

# Phase 4: Refactor
python scripts/find_large_files.py
# ... refactor files ...

# Phase 6: Validate
python scripts/validate_project.py
```

### Partial Execution

Focus on specific modules:

```bash
# Analyze specific module
MODULE=user_module python scripts/analyze_structure.py

# Generate docs for specific modules
MODULES="user,auth,profile" python scripts/generate_module_readmes.py
```

---

## Troubleshooting

If you encounter issues during the workflow:

1. **Check logs**: Review error messages carefully
2. **Revert if needed**: `git reset --hard HEAD~1`
3. **Isolate problem**: Run phases individually
4. **Consult guides**: See detailed guides for each phase
5. **Ask for help**: [Troubleshooting Guide](troubleshooting.md)

---

## After Simplification

### Maintain Cleanliness

- Run analysis monthly
- Refactor when adding features
- Keep documentation updated
- Monitor file sizes
- Review structure quarterly

### Share Knowledge

- Document patterns discovered
- Update team processes
- Improve onboarding materials
- Create architecture docs

### Celebrate

Project simplification complete! Your codebase is now:
✨ More maintainable
✨ Better organized
✨ Well documented
✨ Easier to understand

---

## Additional Resources

- [Analyze Structure Guide](analyze-structure.md)
- [Clean Docs Guide](clean-docs.md)
- [Merge Configs Guide](merge-configs.md)
- [Refactor Files Guide](refactor-files.md)
- [Generate Docs Guide](generate-docs.md)
- [Validate Project Guide](validate.md)
- [Best Practices](best-practices.md)
- [Troubleshooting](troubleshooting.md)
