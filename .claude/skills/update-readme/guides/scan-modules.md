# Scan Modules Guide

## Purpose
Discover and catalog all modules in the Flutter project.

## Steps

1. **List modules**:
   ```bash
   ls lib/ | grep -v -E '^(main|app|router|shared)\.dart$' | grep -v -E '^(router|shared)$'
   ```

2. **For each module**, read:
   - `<module>/AI_ANALYSIS.md` - First paragraph for description
   - `lib/AI_MODULE_INDEX.md` - Module index entry
   - `lib/router/app_route_table.dart` - Registration metadata

3. **Extract**:
   - Module name
   - Category (from ModuleCategory enum)
   - Difficulty level
   - Status
   - Short description/subtitle
   - Key concepts

4. **Output**: Table or list of all modules with metadata

## Validation
- Verify each module directory exists
- Check route registration matches directory name
- Ensure AI_ANALYSIS.md exists for each module
