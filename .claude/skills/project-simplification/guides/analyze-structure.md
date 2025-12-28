# Analyze Project Structure

Understand your Flutter project's layout and identify potential structural issues.

## What This Does

Runs comprehensive analysis to:
- Scan `lib/` directory structure
- Identify modules and their organization
- Find dependencies between modules
- Locate duplicate files and classes
- Report circular dependencies
- Identify overly deep directory hierarchies
- Show unused imports

## Quick Start

```bash
python .claude/skills/project-simplification/scripts/analyze_structure.py
```

## Analysis Output

The script generates `analysis_report.json` containing:

```json
{
  "modules": [...],
  "duplicates": [...],
  "circular_deps": [...],
  "deep_dirs": [...],
  "large_files": [...],
  "unused_imports": [...]
}
```

## What to Look For

After running analysis, review and note:

- **Modules with too many files** (>20 files): Consider splitting into logical sub-modules
- **Duplicate code**: Same class/file exists in multiple places → Consolidate
- **Files exceeding size limits** (>500 lines): Mark for refactoring
- **Problematic directory depth** (>4 levels): Consider flattening structure
- **Circular dependencies**: These need breaking to avoid tight coupling
- **Unused imports**: Clean up to reduce clutter

## Common Issues

### Too Many Files per Module
- **Problem**: Modules with 30+ files become hard to navigate
- **Impact**: Developers struggle to find relevant code
- **Solution**: Split into logical sub-modules by feature or layer

### Duplicate Code
- **Problem**: Same class/file exists in multiple places
- **Impact**: Maintenance nightmare, inconsistency bugs
- **Solution**: Consolidate into shared utilities or services

### Deep Directory Nesting
- **Problem**: Paths like `lib/module/sub/sub/sub/file.dart`
- **Impact**: Long imports, hard to navigate, unclear structure
- **Solution**: Flatten structure to max 3-4 levels

### Large Files
- **Problem**: Files over 500 lines become hard to maintain
- **Impact**: Hard to understand, test, and modify
- **Solution**: Extract logical components (see [Refactor Files guide](refactor-files.md))

## Module-Specific Analysis

To analyze only a specific module:

```bash
MODULE=interceptor_test python .claude/skills/project-simplification/scripts/analyze_structure.py
```

## Review Checklist

- [ ] Which modules have too many files (>20 files)?
- [ ] Where does duplication exist?
- [ ] Which files exceed 500 lines?
- [ ] Are there directories nested >4 levels deep?
- [ ] Any circular dependencies detected?
- [ ] Unused imports to clean up?

## Next Steps

After completing analysis:

1. **Save the report**: Keep `analysis_report.json` for reference
2. **Prioritize issues**: Focus on high-impact problems first
3. **Choose your path**:
   - Large files → Go to [Refactor Files guide](refactor-files.md)
   - Duplicate docs → Go to [Clean Docs guide](clean-docs.md)
   - Config issues → Go to [Merge Configs guide](merge-configs.md)
   - Or continue with complete workflow

## Tips

- **Run Regularly**: Execute analysis after major changes to track progress
- **Track Metrics**: Compare reports over time to measure improvement
- **Share Results**: Discuss findings with team for collective awareness
- **Set Baselines**: Establish acceptable thresholds for your specific project
