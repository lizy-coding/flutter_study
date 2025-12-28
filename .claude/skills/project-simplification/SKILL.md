---
name: project-simplification
description: Simplifies Flutter projects by analyzing structure, cleaning redundant docs, merging configs, refactoring large files, generating module documentation, and running validation tests. Use when optimizing project structure, removing technical debt, improving code organization, or creating project documentation.
allowed-tools: Read, Grep, Glob, Bash(*), Edit, Write
model: claude-sonnet-4-5-20250929
---

# Flutter Project Simplification

This Skill guides comprehensive Flutter project optimization including structure analysis, documentation cleanup, configuration consolidation, file refactoring, and validation.

## Quick Start

Tell Claude:
- "Simplify my Flutter project"
- "Analyze my project structure and suggest improvements"
- "Clean up redundant documentation"
- "Merge duplicate configuration files"
- "Refactor large files"
- "Generate README files for all modules"
- "Create module documentation"
- "Validate and test the project"

## Workflow Overview

The project simplification process consists of six sequential phases:

1. **Analyze Project Structure** - Understand codebase layout and identify issues
2. **Clean Redundant Docs** - Remove duplicate documentation files
3. **Merge Configuration Files** - Consolidate duplicate configs
4. **Refactor Large Files** - Break up oversized files
5. **Generate Documentation** - Create module and root README files
6. **Validate and Test** - Ensure all changes work correctly

## Phase 1: Analyze Project Structure

Run the analysis script to understand your project layout:

```bash
python .claude/skills/project-simplification/scripts/analyze_structure.py
```

This will:
- Scan the lib/ directory structure
- Identify modules and their dependencies
- Find duplicate files and classes
- Report circular dependencies
- List overly deep directory hierarchies
- Show unused imports

Review the analysis report and note:
- Which modules have too many files
- Where duplication exists
- Which files exceed recommended sizes
- Problematic directory depth

## Phase 2: Clean Redundant Docs

Identify and remove duplicate or outdated documentation:

```bash
python .claude/skills/project-simplification/scripts/find_redundant_docs.py
```

For each redundant document:
1. Review its content
2. Check if it's referenced elsewhere
3. Merge content into primary documentation if needed
4. Delete the redundant file
5. Update any references

Common redundant docs in Flutter projects:
- Duplicate README files in subdirectories
- Outdated CHANGELOG entries
- Duplicate API documentation
- Overlapping architecture documentation

## Phase 3: Merge Configuration Files

Consolidate duplicate configuration files:

```bash
python .claude/skills/project-simplification/scripts/find_duplicate_configs.py
```

For configuration merging:
1. Identify all config files (pubspec.yaml, analysis_options.yaml, etc.)
2. Check for duplicate entries
3. Create consolidated configuration
4. Update all references
5. Verify all modules use the merged config

Example merge scenarios:
- **pubspec.yaml**: Consolidate if split across modules
- **analysis_options.yaml**: Merge linter rules
- **build.yaml**: Merge build configurations
- **firebase.json**: Consolidate settings
- **.gitignore**: Merge into single root file

## Phase 4: Refactor Large Files

Break up files that are too large (>500 lines recommended):

```bash
python .claude/skills/project-simplification/scripts/find_large_files.py
```

For each file identified for refactoring:
1. Analyze its responsibilities
2. Identify logical components
3. Extract to separate files following:
   - Single Responsibility Principle
   - Clear module boundaries
   - Consistent naming patterns
4. Update imports in all files
5. Verify no functionality changed

Refactoring strategies:
- **Large State Classes**: Extract models, services separately
- **Large Widgets**: Extract sub-widgets and helpers
- **Large Services**: Split by functionality domains
- **Large Models**: Separate validation, serialization, display logic

## Phase 5: Generate Documentation

Automatically generate comprehensive README files for all modules and the project root:

### Step 5.1: Generate Module Descriptions

Analyze all modules and extract information:

```bash
python .claude/skills/project-simplification/scripts/generate_module_descriptions.py
```

This script:
- Scans all modules in `lib/` directory
- Extracts descriptions from comments
- Identifies pages, widgets, models, services
- Counts files and lines of code
- Detects dependencies
- Generates `module_descriptions.json`

### Step 5.2: Generate Module READMEs

Create individual README for each module:

```bash
python .claude/skills/project-simplification/scripts/generate_module_readmes.py
```

Each module README includes:
- Module overview and description
- Feature list
- Project structure tree
- Main files description
- Usage examples
- Code samples
- Tech stack
- File statistics
- Dependencies
- Test information

Output: `lib/<module_name>/README.md` for each module

### Step 5.3: Generate Root README

Create comprehensive project README:

```bash
python .claude/skills/project-simplification/scripts/generate_root_readme.py
```

Root README includes:
- Project overview and statistics
- Complete module list with links
- Module categorization (UI/Async/Arch/Network)
- Learning paths (beginner/advanced)
- Quick start guide
- Project structure
- Tech stack
- Development tools
- Contributing guide

Output: `README.md` at project root

### One-Command Generation

Generate all documentation at once:

```bash
python .claude/skills/project-simplification/scripts/generate_module_descriptions.py && \
python .claude/skills/project-simplification/scripts/generate_module_readmes.py && \
python .claude/skills/project-simplification/scripts/generate_root_readme.py
```

### Documentation Best Practices

1. **Regular Updates**: Regenerate after adding/modifying modules
2. **Manual Review**: Check generated content for accuracy
3. **Custom Descriptions**: Add detailed comments in module entry files
4. **Code Examples**: Enhance with practical examples
5. **Keep Links Valid**: Verify all internal links work

For detailed guidance, see [readme-generation.md](readme-generation.md)

## Phase 6: Validate and Test

Run comprehensive validation to ensure quality:

```bash
python .claude/skills/project-simplification/scripts/validate_project.py
```

This checks:
- **Code Quality**: Run `flutter analyze`
- **Build Integrity**: Run `flutter pub get` and check imports
- **Test Coverage**: Run existing tests
- **File Organization**: Verify module structure
- **Dependency Health**: Check for unused dependencies
- **Documentation**: Verify links and references

## Step-by-Step Workflow

### Step 1: Initial Analysis (15 mins)
```bash
# Analyze structure and gather metrics
python .claude/skills/project-simplification/scripts/analyze_structure.py

# Review the analysis report in detail
cat analysis_report.json
```

### Step 2: Documentation Cleanup (10 mins)
```bash
# Find redundant docs
python .claude/skills/project-simplification/scripts/find_redundant_docs.py

# Review duplicates
grep -r "README\|CHANGELOG\|API" . --include="*.md"
```

### Step 3: Configuration Consolidation (15 mins)
```bash
# Find duplicate configs
python .claude/skills/project-simplification/scripts/find_duplicate_configs.py
```

### Step 4: Large File Refactoring (30 mins)
```bash
# Identify oversized files
python .claude/skills/project-simplification/scripts/find_large_files.py

# Refactor identified files (manual or assisted)
```

### Step 5: Generate Documentation (15 mins)
```bash
# Generate all documentation
python .claude/skills/project-simplification/scripts/generate_module_descriptions.py && \
python .claude/skills/project-simplification/scripts/generate_module_readmes.py && \
python .claude/skills/project-simplification/scripts/generate_root_readme.py

# Review generated READMEs
ls lib/*/README.md
cat README.md
```

### Step 6: Comprehensive Validation (20 mins)
```bash
# Run all validation checks
python .claude/skills/project-simplification/scripts/validate_project.py

# Run Flutter analysis
flutter analyze

# Run tests
flutter test
```

## Configuration Options

Pass options to scripts via environment variables:

```bash
# Analyze only specific module
MODULE=interceptor_test python .claude/skills/project-simplification/scripts/analyze_structure.py

# Use custom file size threshold (lines)
FILE_SIZE_THRESHOLD=400 python .claude/skills/project-simplification/scripts/find_large_files.py

# Check specific doc patterns
DOC_PATTERNS="README,CHANGELOG,GUIDE" python .claude/skills/project-simplification/scripts/find_redundant_docs.py
```

## Best Practices for Project Simplification

1. **Version Control**: Commit before each phase
2. **Incremental Changes**: Don't refactor everything at once
3. **Testing**: Run tests after each phase
4. **Code Review**: Have teammates review large refactorings
5. **Documentation**: Update docs during refactoring, not after
6. **Performance**: Profile after significant refactoring
7. **Git History**: Use descriptive commit messages

## Troubleshooting

### Script Not Found
Ensure scripts are in the skill directory with execute permissions:
```bash
chmod +x .claude/skills/project-simplification/scripts/*.py
```

### Python Dependencies
Install required packages if needed:
```bash
pip install pathspec
```

### Large Files List Incomplete
The script uses heuristics. Manually review files over 400 lines.

### Build Fails After Changes
1. Run `flutter pub get` to refresh dependencies
2. Check import statements in refactored files
3. Run `flutter analyze` to find issues
4. Verify no circular dependencies

## Files and References

- For detailed structure analysis: [analysis.md](analysis.md)
- For configuration examples: [config-merge.md](config-merge.md)
- For refactoring patterns: [refactoring-patterns.md](refactoring-patterns.md)
- For README generation guide: [readme-generation.md](readme-generation.md)
- Helper scripts: `scripts/` directory

## Summary

This Skill automates the discovery and execution of project simplification tasks:

✓ Identifies structural issues automatically
✓ Guides documentation cleanup
✓ Consolidates configurations
✓ Refactors oversized files
✓ Generates comprehensive documentation
✓ Validates all changes
✓ Provides step-by-step guidance
✓ Offers configuration options

## Available Scripts

### Analysis & Discovery
- `analyze_structure.py` - Analyze project structure and metrics
- `find_redundant_docs.py` - Find duplicate documentation
- `find_large_files.py` - Identify files needing refactoring
- `find_duplicate_configs.py` - Find duplicate configurations

### Documentation Generation
- `generate_module_descriptions.py` - Extract module information
- `generate_module_readmes.py` - Create module README files
- `generate_root_readme.py` - Create project root README

### Validation
- `validate_project.py` - Run comprehensive quality checks
